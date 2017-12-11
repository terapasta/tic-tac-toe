set :branch, ENV['BRANCH'] || 'master'
server '13.230.166.26', user: 'deploy', roles: %w{web app batch bot_framework}
server '52.193.239.222', user: 'deploy', roles: %w{web app bot_framework}

namespace :deploy do
  task :prepare_bundle_config do
      on roles(:app) do
        execute 'bundle config --local build.mysql2 "--with-mysql-lib=/var/lib/mysql"'
      end
    end
  before 'bundler:install', 'deploy:prepare_bundle_config'
end