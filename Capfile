load 'deploy' if respond_to?(:namespace)

set :application, "mustache.me"
set :user, "jakedahn"
set :use_sudo, false

set :scm, :git
set :repository,  "git@github.com:jakedahn/markup_is_art.git"
set :deploy_via, :remote_cache
set :deploy_to, "/var/www/ruby/#{application}"

role :app, "markupisart.com"
role :web, "markupisart.com"
role :db,  "markupisart.com", :primary => true

set :runner, user
set :admin_runner, user

namespace :deploy do
  task :start, :roles => [:web, :app] do
    run "cd #{deploy_to}/current && nohup thin -C config/production_config.yml -R config.ru start"
  end
 
  task :stop, :roles => [:web, :app] do
    run "cd #{deploy_to}/current && nohup thin -C config/production_config.yml -R config.ru stop"
  end
 
  task :restart, :roles => [:web, :app] do
    deploy.stop
    deploy.start
  end
 
  task :cold do
    deploy.update
    deploy.start
  end
end

namespace :markupisart do
  task :log do
    run "cat #{deploy_to}/current/log/thin.log"
  end
end