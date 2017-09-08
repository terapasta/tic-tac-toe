set :branch, ENV['BRANCH'] || 'develop'
server '54.238.130.37', user: 'deploy', roles: %w{web app batch}
