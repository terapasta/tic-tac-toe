set :branch, ENV['BRANCH'] || 'develop'
server '13.114.217.197', user: 'deploy', roles: %w{web app batch}
