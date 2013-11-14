
set :stage, :staging
set :rails_env, :staging
set :branch, fetch(:stage)

server '192.168.122.10', {
  port: 2222,
  user: fetch(:user),
  roles: %w(web app db),
  ssh_options: {
    keys: %w(~/.ssh/id_rsa),    # Keeping it in as I will want to change this later
    auth_methods: %w(publickey)
  }
}

# fetch(:default_env).merge!(rails_env: :staging)
