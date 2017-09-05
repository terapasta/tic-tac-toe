set :branch, ENV['BRANCH'] || 'develop'
server '?.?.?.?', user: 'deploy', roles: %w{web app batch}
