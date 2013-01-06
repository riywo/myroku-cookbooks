#
# Cookbook Name:: myroku
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
script "mysql_secure_installation" do
  interpreter "expect"
  user "root"
  code <<-EOF
spawn mysql_secure_installation
expect "Enter current password for root (enter for none):"
send "#{node['mysql']['server_root_password']}\\n"
expect "Change the root password?"
send "n\\n"
expect "Remove anonymous users?"
send "Y\\n"
expect "Disallow root login remotely?"
send "Y\\n"
expect "Remove test database and access to it?"
send "Y\\n"
expect "Reload privilege tables now?"
send "Y\\n"
interact
  EOF
end

template "/root/myroku-grants.sql" do
  source "grants.sql.erb"
  variables :grant => node['myroku']['mysql_user']
end

execute "grant mysql" do
  command "cat /root/myroku-grants.sql | mysql -uroot -p#{node['mysql']['server_root_password']}"
end

execute "create database" do
  command "echo 'CREATE DATABASE IF NOT EXISTS #{node['myroku']['mysql_db']}' | mysql -uroot -p#{node['mysql']['server_root_password']}"
end
