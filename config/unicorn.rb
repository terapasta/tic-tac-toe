working_directory '/var/www/donusagi-bot/current'
worker_processes 2
timeout 300

listen  '/tmp/unicorn.sock'
pid     '/tmp/unicorn.pid'

stderr_path File.expand_path('log/unicorn.stderr.log', ENV['RAILS_ROOT'])
stdout_path File.expand_path('log/unicorn.stdout.log', ENV['RAILS_ROOT'])

current_dir = "/var/www/donusagi-bot/current"
before_exec do |server|
  ENV['BUNDLE_GEMFILE'] = File.expand_path('Gemfile', current_dir)
end

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!

  old_pid = "#{ server.config[:pid] }.oldbin"
  if old_pid != server.pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end

  sleep 1
end

after_fork do |_server, _worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end
