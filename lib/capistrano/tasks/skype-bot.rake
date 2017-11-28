namespace :skype_bot do
  task :environment do
    set :skype_bot_pid, "#{shared_path}/tmp/pids/skype-bot.pid"
  end

  def start_skype_bot
    execute :sudo, '/sbin/start', 'skype-bot'
  end

  def stop_skype_bot
    execute :sudo, '/sbin/stop', 'skype-bot'
  end

  def restart_skype_bot
    execute :sudo, '/sbin/restart', 'skype-bot'
  end

  desc 'Start skype-bot'
  task start: :environment do
    on roles(:app) do
      start_skype_bot
    end
  end

  desc 'Stop skype-bot'
  task stop: :environment do
    on roles(:app) do
      stop_skype_bot
    end
  end

  desc 'Restart skype-bot'
  task restart: :environment do
    on roles(:app) do
      if test("[ -f #{fetch(:skype_bot_pid)} ]")
        restart_skype_bot
      else
        start_skype_bot
      end
    end
  end
end
