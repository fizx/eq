set :application, "eq"
set :scm, "git"
set :repository,  "git@github.com:fizx/eq.git"
set :user, "www-data"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/var/www/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

role :app, "kylemaxwell.com"
# role :web, "your web-server here"
# role :db,  "your db-server here", :primary => true

namespace :deploy do
  task :restart do 
    run "touch #{current_path}/tmp/restart.txt"
  end
  
  task :migrate do 
    run "cd #{current_path} && rake db:migrate RAILS_ENV=production"
  end
  
end