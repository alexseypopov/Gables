set :deploy_to, "/var/www/tablet.gables"
set :branch,    "tablet"
set :rails_env, "staging"
server "107.21.111.69", :app, :web, :db, :primary => true
