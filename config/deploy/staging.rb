set :deploy_to, "/var/www/staging.gables"
set :branch,    "Mobile"
set :rails_env, "staging"
server "23.21.2.205", :app, :web, :db, :primary => true
