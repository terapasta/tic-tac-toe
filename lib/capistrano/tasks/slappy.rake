namespace :slappy do
  task :environment do
    set :slappy_pid, "#{shared_path}/tmp/pids/slappy.pid"
  end

  def start_slappy
    sudo :start, :slappy
  end

  def stop_slappy
    sudo :stop, :slappy
  end

  def restart_slappy
    sudo :restart, :slappy
  end

  desc 'Start slappy'
  task start: :environment do
    on roles(:app) do
      start_slappy
    end
  end

  desc 'Stop slappy'
  task stop: :environment do
    on roles(:app) do
      stop_slappy
    end
  end

  desc 'Restart slappy'
  task restart: :environment do
    on roles(:app) do
      if test("[ -f #{fetch(:slappy_pid)} ]")
        restart_slappy
      else
        start_slappy
      end
    end
  end
end
