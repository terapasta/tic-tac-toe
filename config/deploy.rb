# config valid only for current version of Capistrano
lock '3.6.1'

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
set :linked_dirs, %w{log tmp/backup tmp/pids tmp/cache tmp/sockets vendor/bundle public/uploads learning/dumps learning/logs}

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

  desc 'python engineを移動'
  task :move_engine do
    on roles(:app) do
      execute :cp, shared_path.join('.python-version'), release_path.join('learning/.python-version')
      # execute :cp, shared_path.join('config.yml'), release_path.join('learning/learning/config/config.yml')
      within current_path.join('learning') do
        sudo :pip, :install, '-r requirements.txt'
      end
      sudo :supervisorctl, :reload, '-c /etc/supervisord.conf'
      pid = capture '/usr/sbin/lsof', '-i:6000', '-t'
      execute :kill, pid
    end
  end

  after :finished, 'deploy:move_engine'
  after :finished, 'slappy:restart'
  # after :finished, 'update_neologd'
end
