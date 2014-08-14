require "bundler/capistrano"

set :application, "UnturnedServers"

set :scm, :git
set :repository, "git@github.com:Jake0oo0/UnturnedServers.git"
set :branch, "master"
set :deploy_via, :remote_cache
set :deploy_to, "/home/deployer/UnturnedServers"
set :user, "deployer"
set :use_sudo, false
set :rails_env, :production

ssh_options[:forward_agent] = true
default_run_options[:shell] = '/bin/bash --login'

server "unturned.jake0oo0.me", :app, :web, :db, :primary => true

namespace :passenger do
	desc "Restart Application"
	task :restart do
		run "touch #{current_path}/tmp/restart.txt"
	end
end

namespace :config do
	desc "Manage sensitive config info."
	task :setup do
		run "cat #{shared_path}/github.txt > #{current_path}/config/initializers/secrets.rb"
		run "cat #{shared_path}/secret.txt > #{current_path}/config/initializers/secret_token.rb"
	end
end

after :deploy, "config:setup"
after :deploy, "passenger:restart"