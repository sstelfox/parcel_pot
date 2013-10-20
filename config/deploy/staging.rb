
set :stage, :staging
set :branch, fetch(:stage)

server '192.168.122.40', {
  user: 'deploy',
  roles: %w(web app db),
  ssh_options: {
    keys: %w(~/.ssh/id_rsa),    # Keeping it in as I will want to change this later
    auth_methods: %w(publickey)
  }
}

# fetch(:default_env).merge!(rails_env: :staging)
