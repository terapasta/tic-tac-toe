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

set :linked_files, %w{.env .python-version learning/config/config.yml config/database.yml}
set :linked_dirs, %w{log tmp/backup tmp/pids tmp/cache tmp/sockets vendor/bundle public/uploads public/packs learning/dumps learning/logs node_modules}

set :bundle_jobs, 4
set :unicorn_pid, "/tmp/unicorn.pid"
set :unicorn_config_path, 'config/unicorn.rb'
set :whenever_identifier, ->{"#{fetch(:application)}_#{fetch(:stage)}}"}
set :whenever_roles, ->{ :batch }
set :delayed_job_roles, [:worker]

desc 'mecab ipadic neologdをアップデート'
task :update_neologd do
  on roles(:app) do
    sudo 'install-neologd.sh'
  end
end

namespace :deploy do
  task :copy_assets_manifest do
    next unless roles(:web, :app).count > 1
    assets_manifest_name = nil
    assets_manifest_contents = nil
    assets_manifest_path = nil
    packs_manifest_name = nil
    packs_manifest_contents = nil
    packs_manifest_path = nil

    assets_path = release_path.join('public', 'assets')
    packs_path = release_path.join('public', 'packs')
    assets_manifest_pattern = assets_path.join('.sprockets-manifest*')
    packs_manifest_path = packs_path.join('manifest.json')

    on roles(fetch(:assets_roles)), primary: true do
      assets_manifest_name = capture(:ls, assets_manifest_pattern).strip
      assets_manifest_path = assets_path.join(assets_manifest_name)
      assets_manifest_contents = download! assets_manifest_path
      packs_manifest_contents = download! packs_manifest_path
    end
    on roles(:app) do
      execute :rm, '-f', assets_manifest_pattern
      execute :rm, '-f', packs_manifest_path
      upload! StringIO.new(assets_manifest_contents), assets_manifest_path
      upload! StringIO.new(packs_manifest_contents), packs_manifest_path
    end
  end

  after "deploy:compile_assets", :copy_assets_manifest
  after "deploy:rollback_assets", :copy_assets_manifest

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
    on roles(:learning) do
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