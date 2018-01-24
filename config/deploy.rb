# config valid only for current version of Capistrano
lock '3.6.1'

set :user, 'deploy'
set :pty, true
set :application, 'donusagi-bot'
set :repo_url, 'git@github.com:mofmof/donusagi-bot.git'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/var/www/donusagi-bot'
set :rbenv_type, :system
set :rbenv_ruby, File.read('.ruby-version').strip
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all
set :migration_role, 'web'

set :linked_files, %w{.env .python-version learning/config/config.yml config/database.yml}
set :linked_dirs, %w{log tmp/backup tmp/pids tmp/cache tmp/sockets vendor/bundle public/uploads public/packs learning/dumps learning/logs}

set :bundle_jobs, 4
set :unicorn_pid, "/tmp/unicorn.pid"
set :unicorn_config_path, 'config/unicorn.rb'
set :whenever_identifier, ->{"#{fetch(:application)}_#{fetch(:stage)}}"}
set :whenever_roles, ->{ :batch }

desc 'mecab ipadic neologdをアップデート'
task :update_neologd do
  on roles(:app) do
    sudo 'install-neologd.sh'
  end
end

namespace :deploy do
  Rake::Task['deploy:assets:precompile'].clear_actions
  namespace :assets do
    desc 'Run the precompile task locally and rsync with shared'
    task :precompile do
      on roles(:web), reject: -> (h) { h.properties.no_release } do
        rsync_host = "#{fetch(:user)}@#{fetch(:host)}:#{shared_path}/public"
        %x{bundle exec rake assets:precompile}
        %x{rsync --recursive --times --rsh=ssh --compress --human-readable --progress public/assets #{rsync_host}}
        %x{rsync --recursive --times --rsh=ssh --compress --human-readable --progress public/packs #{rsync_host}}
        %x{bundle exec rake assets:clean}
      end
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'unicorn:restart'
    end
  end

  after :publishing, :restart
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
    end
  end

  desc 'python用ファイルアップロード(必要な場合のみ実行しましょう)'
  task :python_upload do
    on roles(:app) do
      upload!('./.python-version.example', shared_path.join('.python-version'))
      # config.ymlは本番設定のものが必要
      # upload!('./config.yml', shared_path.join('config.yml'))
      upload!('./supervisord.conf', '/var/www/donusagi-bot/supervisord.conf')
    end
  end

  task :restart_python do
    on roles(:app) do
      execute :cp, shared_path.join('.python-version'), release_path.join('learning/.python-version')
      # execute :cp, shared_path.join('config.yml'), release_path.join('learning/learning/config/config.yml')
      within current_path.join('learning') do
        sudo :pip, :install, '-r requirements.txt'
      end
      sudo :supervisorctl, :restart, :engine, '-c /etc/supervisord.conf'

      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'ml_engine:setup'
        end
      end
    end
  end

  task :restart_botapi do
    on roles(:bot_framework) do
      within current_path.join('bot-framework') do
        execute :yarn, :install, '--silent'
      end
      sudo :supervisorctl, :restart, :botapi, '-c /etc/supervisord.conf'
    end
  end

  after :finished, 'deploy:restart_python'
  after :finished, 'deploy:restart_botapi'
  # after :finished, 'update_neologd'
end

namespace :webpacker do
  task :disable_yarn_install => :yarn_install do
    # workaround to stop running yarn install after precompile
  end
end