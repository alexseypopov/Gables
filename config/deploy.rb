require "bundler/capistrano"
require "airbrake/capistrano" 
require 'capistrano/ext/multistage'

set :application, "gables"
set :repository,  "git@github.com:digitalscientists/gables.git"
set :scm, :git

set :stages, %w(tablet staging production)
set :default_stage, "staging"

set :deploy_via, :remote_cache
set(:shared_path){"#{deploy_to}/shared"}
set :user, "rails"
set :use_sudo, false
set :port, ENV['PORT'] || "30306"
set :keep_releases, 5 

# ssh_options[:keys] = [File.join(File.dirname(__FILE__), 'id_rsa.pub')]

after "deploy:create_symlink" do
  run "cd #{latest_release}/public && ln -s #{shared_path}/public/assets"
  run "cd #{latest_release}/public && ln -s #{shared_path}/public/find"
end

after "deploy", "deploy:migrate"
after "deploy:restart", "deploy:cleanup" 

namespace :deploy do
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

load 'deploy/assets'
