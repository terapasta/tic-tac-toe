set :branch, ENV['BRANCH'] || 'develop'
set :keep_releases, 2
server '13.114.217.197', user: 'deploy', roles: %w{web app batch}
