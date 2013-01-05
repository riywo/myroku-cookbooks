require 'pathname'
current_dir = Pathname File.expand_path('../', __FILE__)

file_cache_path "/tmp/chef-solo"
cookbook_path   [current_dir+"cookbooks", current_dir+"vendor/cookbooks"]
role_path       current_dir+"roles"
