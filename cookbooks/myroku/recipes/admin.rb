#
# Cookbook Name:: myroku
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'myroku::ruby'

myroku_user = node['myroku']['username']
myroku_home = "#{node['user']['home_root']}/#{myroku_user}"
admin_server = node['myroku']['servers']['admin']

node.set['gitolite2']['public_key_path'] = "#{myroku_home}/.ssh/id_rsa.pub"
node.set['gitolite2']['local_code'] = "/var/myroku/myroku-server/current"
node.set['gitolite2']['post_git'] = ["post_git"]
include_recipe "gitolite2"

servers = (node['myroku']['servers']['app'] + node['myroku']['servers']['proxy'] + node['myroku']['servers']['db']).uniq
servers.push('localhost')
servers.each do |server|
  execute "add #{server} to known_hosts" do
    user myroku_user
    group myroku_user
    cwd myroku_home
    command "ssh-keyscan #{server} >> #{myroku_home}/.ssh/known_hosts"
    not_if "grep -q \"`ssh-keyscan #{server}`\" #{myroku_home}/.ssh/known_hosts"
  end
end

execute "gitconfig user" do
  user myroku_user
  group myroku_user
  cwd myroku_home
  environment ({'HOME' => myroku_home})
  command "git config --global user.name #{myroku_user}"
  not_if "git config --global --get user.name"
end

execute "gitconfig email" do
  user myroku_user
  group myroku_user
  cwd myroku_home
  environment ({'HOME' => myroku_home})
  command "git config --global user.email #{myroku_user}@localhost"
  not_if "git config --global --get user.email"
end

execute "git clone gitolite-admin" do
  user myroku_user
  group myroku_user
  cwd myroku_home
  environment ({'HOME' => myroku_home})
  command "git clone git@localhost:gitolite-admin /var/myroku/gitolite-admin"
  not_if {File.exists? "/var/myroku/gitolite-admin"}
end

directory "/var/log/myroku" do
  owner myroku_user
  group myroku_user
end

execute "git clone myroku-server" do
  user myroku_user
  group myroku_user
  cwd myroku_home
  environment ({'HOME' => myroku_home})
  command "git clone https://github.com/riywo/myroku-server.git #{myroku_home}/myroku-server"
  not_if {File.exists? "#{myroku_home}/myroku-server"}
end

execute "bash -l -c 'rbenv local #{node['myroku']['ruby_version']}'" do
  user  myroku_user
  group myroku_user
  cwd   "#{myroku_home}/myroku-server"
  environment ({'HOME' => myroku_home})
end

require 'yaml'
file "#{myroku_home}/myroku-server/config/servers.yml" do
  owner myroku_user
  group myroku_user
  content YAML.dump(node['myroku']['servers'].to_hash)
end

execute "add DATABASE_URL to .env" do
  database_url = "mysql2://#{node['myroku']['mysql_user']['user']}:#{node['myroku']['mysql_user']['password']}@#{admin_server}/#{node['myroku']['mysql_db']}"
  user myroku_user
  group myroku_user
  cwd myroku_home
  environment ({'HOME' => myroku_home})
  command "echo 'DATABASE_URL=\"#{database_url}\"' >> #{myroku_home}/myroku-server/.env"
  not_if "grep 'DATABASE_URL=\"#{database_url}\"' #{myroku_home}/myroku-server/.env"
end

execute "add REDIS_URL to .env" do
  redis_url = "redis://#{admin_server}/0"
  user myroku_user
  group myroku_user
  cwd myroku_home
  environment ({'HOME' => myroku_home})
  command "echo 'REDIS_URL=\"#{redis_url}\"' >> #{myroku_home}/myroku-server/.env"
  not_if "grep 'REDIS_URL=\"#{redis_url}\"' #{myroku_home}/myroku-server/.env"
end
