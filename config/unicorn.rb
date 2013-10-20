
# Configure the working directories root
APP_ROOT = File.expand_path(File.dirname(File.dirname(__FILE__)))
working_directory APP_ROOT
 
worker_processes 4
 
# Preload the application too speed up forking and optimize memory usage.
preload_app true
 
# Lower the timeout, 10 seconds is far too long as it is
timeout 10
 
# Use a local socket for the connections (to be proxied to by nginx)
listen APP_ROOT + "/tmp/sockets/unicorn.sock", :backlog => 64

# The location of the master pid file
pid APP_ROOT + "/tmp/pids/unicorn.pid"
 
# Setup some local logging
stderr_path APP_ROOT + "/log/unicorn.stderr.log"
stdout_path APP_ROOT + "/log/unicorn.stdout.log"
 
before_fork do |server, worker|
  # Disconnect from our database, when we fork there would be race conditions
  # and all kinds of messy shared sockets if this didn't happen.
  defined?(ActiveRecord::Base) && ActiveRecord::Base.connection.disconnect!
end
 
after_fork do |server, worker|
  # Setup our database connections again
  defined?(ActiveRecord::Base) && ActiveRecord::Base.establish_connection
 
  # Record chlid process PIDs
  worker_pid_file = server.config[:pid].sub('.pid', ".#{worker.nr}.pid")
  File.open(worker_pid_file, 'w') { |f| f.write(Process.pid) }
  system("echo #{Process.pid} > #{child_pid}")
end

