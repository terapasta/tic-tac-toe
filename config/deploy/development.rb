set :branch, ENV['BRANCH'] || 'develop'
server '192.168.33.13', user: 'deploy', roles: %w{web app batch}
