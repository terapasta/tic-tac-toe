# config valid only for current version of Capistrano
lock '3.6.1'

set :application, 'donusagi-bot'
set :repo_url, 'git@github.com:mofmof/donusagi-bot.git'

set :branch, ENV['BRANCH'] || 'master'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/var/www/donusagi-bot'
set :rbenv_type, :system
set :rbenv_ruby, File.read('.ruby-version').strip
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all
set :migration_role, 'web'

set :linked_files, %w{.env}
set :linked_dirs, %w{bin log tmp/backup tmp/pids tmp/cache tmp/sockets vendor/bundle}

set :bundle_jobs, 4
set :unicorn_pid, "/tmp/unicorn.pid"
set :unicorn_config_path, 'config/unicorn.rb'

namespace :deploy do

  desc 'Upload config files'
  task :upload do
    on roles(:app) do |host|
      if test "[ ! -d #{shared_path}/config ]"
        execute "mkdir -p #{shared_path}/config"
      end
      upload!('.env.example', "#{shared_path}/.env")
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
end
