set :application, "myroku-cookbooks"
set :scm, :git
set :repository,  "git@github.com:riywo/myroku-cookbooks.git"

role :web, "192.168.110.111"

set :user, 'vagrant'
set :password, 'vagrant'

set :deploy_to, "/home/#{user}/#{application}"
set :use_sudo, false

namespace :cookbooks do
  desc "Deploy cookbooks"
  task :deploy do
    run "mkdir -p #{release_path}/vendor"
    upload "vendor/cookbooks", "#{release_path}/vendor/cookbooks"
  end
  before 'deploy:finalize_update', 'cookbooks:deploy'
end

namespace :chef do
  task :solo do
    run "#{sudo} chef-solo -c #{deploy_to}/current/solo.rb -j #{deploy_to}/current/vagrant.json"
  end
end
