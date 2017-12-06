set :branch, ENV['BRANCH'] || 'master'
server '54.92.55.255', user: 'deploy', roles: %w{web app batch bot_framework}
