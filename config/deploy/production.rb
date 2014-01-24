set :deploy_to, "/var/www/gables"
set :branch, "master"
set :rails_env, "production"
server "50.17.194.39", :app, :web, :db, :primary => true
