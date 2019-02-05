set :branch, ENV['BRANCH'] || 'develop'
set :keep_releases, 2
server '52.68.42.169', user: 'deploy', roles: %w{web app db batch worker bot_framework learning}
