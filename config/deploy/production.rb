set :branch, ENV['BRANCH'] || 'master'

MyOpeProductionA = '13.230.166.26'
MyOpeProductionB = '52.193.239.222'

server MyOpeProductionA,
  user: 'deploy',
  roles: %w{web app db batch bot_framework}
server MyOpeProductionB,
  user: 'deploy',
  roles: %w{app bot_framework}

namespace :deploy do
  task :prepare_bundle_config do
      on roles(:app) do
        execute 'bundle config --local build.mysql2 "--with-mysql-lib=/var/lib/mysql"'
      end
    end
  before 'bundler:install', 'deploy:prepare_bundle_config'
end