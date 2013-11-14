
set :application, 'parcel_pot'
set :repo_url,    'git@github.com:sstelfox/parcel_pot.git'
set :user,        'deployer'

# This should eventually be set by the environment
set :branch, 'master'
set :scm, :git
set :deploy_via, :remote_cache

# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :deploy_to, "/home/#{fetch(:user)}/#{fetch(:application)}"

# set :format, :pretty
set :log_level, :debug
# set :pty, true

set :linked_files, %w{ config/database.yml }
set :linked_dirs, %w{ db log tmp/pids tmp/cache tmp/sockets }

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :keep_releases, 5

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  task :export_systemd do
    on roles(:app) do
      sudo "#{deploy_path.join('current/bin/foreman')} export systemd /usr/lib/systemd/system -f #{release_path.join('Procfile')} -a parcel_pot -u deploy"
    end
  end

  task :enable_service do
    on roles(:app) do
      sudo :systemctl, "enable #{fetch(:application)}.target"
      sudo :systemctl, "--system daemon-reload"
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after 'deploy:finishing', 'deploy:cleanup'
end

#after 'deploy:updated', 'deploy:export_systemd'
#after 'deploy:export_systemd', 'deploy:enable_service'

