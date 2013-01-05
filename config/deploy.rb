set :stages, %w(default vagrant)
set :default_stage, "default"
require 'capistrano/ext/multistage'

set :application, "myroku-cookbooks"
set :scm, :git
set :repository,  "git@github.com:riywo/myroku-cookbooks.git"
set(:deploy_to) { "/home/#{user}/#{application}" }
set :use_sudo, false

set(:chef_dir) { File.join(deploy_to, "current") }

require 'json'
namespace :chef do
  task :default do
    cookbooks
    config
    attribute
    solo
  end
  after 'deploy:finalize_update', 'chef:default'

  task :cookbooks do
    run "mkdir -p #{chef_dir}/vendor"
    upload "vendor/cookbooks", "#{chef_dir}/vendor/cookbooks"
  end

  task :config do
    run "mkdir -p #{chef_dir}/cache"
    file = <<-RUBY
      require 'pathname'
      root = Pathname File.expand_path('../', __FILE__)
      
      file_cache_path root + "cache"
      cookbook_path   [ root + "cookbooks", root + "vendor/cookbooks"]
      role_path       root + "roles"
    RUBY
    put file, solo_rb
  end

  task :attribute do
    servers = find_servers_for_task(current_task)
    servers.each do |server|
      roles = role_names_for_host(server)
      json = default_attribute
      json[:run_list] = roles.map do |role|
        "role[myroku_#{role}]"
      end
      json[:myroku][:servers] = all_servers
      put JSON.pretty_generate(json), node_json
    end
  end

  task :solo do
    run "#{sudo} chef-solo -c #{solo_rb} -j #{node_json}"
  end

  def solo_rb
    File.join(chef_dir, "solo.rb")
  end

  def node_json
    File.join(chef_dir, "node.json")
  end

  def all_servers
    servers = {}
    roles.each do |role, obj|
      servers[role] = obj.servers
    end
    servers
  end
end
