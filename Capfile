
# Load DSL and Setup Up Stages
require 'capistrano/setup'

# Includes default deployment tasks
require 'capistrano/deploy'

# Additional project specific addons
require 'capistrano/bundler'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'

# Hack to fix capistrano/rails developers stubborness
SSHKit.config.command_map[:rake]  = "bundle exec rake"
SSHKit.config.command_map[:rails] = "bundle exec rails"

# Loads custom tasks from `lib/capistrano/tasks' if you have any defined.
Dir.glob('lib/capistrano/tasks/*.cap').each { |r| import r }

namespace :deploy do
  namespace :check do
    desc "Check we have write permissions"
    task :permissions do
      on roles(:app) do |host|
        if test("[ -w #{fetch(:deploy_to)} ]")
          info "#{fetch(:deploy_to)} is writable on #{host}"
        else
          error "#{fetch(:deploy_to)} is not writable on #{host}"
        end
      end
    end
  end
end

before 'deploy:check:directories', 'deploy:check:permissions'
