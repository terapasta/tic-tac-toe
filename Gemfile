source 'https://rubygems.org'
ruby '2.3.4'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.4'
gem 'rake', '< 11'

# select DB for local server
#gem 'mysql2'
# gem 'sqlite3', :group => :development
gem 'mysql2', '~> 0.3.20'


# Use SCSS for stylesheets
gem 'sass'
gem 'sass-rails', '~> 5.0'
gem 'font-awesome-rails'
gem 'tether-rails'

# easy to write a form
gem 'bootstrap-sass'
gem 'bootstrap_form'
#gem 'simple_form' #代替案

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# pagination
gem 'kaminari'

# search form
gem 'ransack'

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# login
gem 'devise'
gem 'devise-bootstrap-views'
gem 'devise-i18n'
gem 'devise-i18n-views'

# admin pages
gem 'rails_admin', '~> 1.1.1'

# enum with i18n
gem 'enum_help'

# Use Unicorn as the app server
gem 'unicorn'

# Zendesk API
gem 'zendesk_api'

# Use zendesk API parameter
gem 'virtus'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Seed Data Management
gem 'seed-fu', '~> 2.3'
gem 'active_hash'
gem 'msgpack-rpc', '~> 0.5.4'
gem 'dotenv-rails'
gem 'rails_autolink'
gem 'twitter'
gem 'http'
gem 'whenever', require: false
gem 'carrierwave', '~> 1.1.0'
gem 'rmagick', require: false
gem 'rails4-autocomplete'
gem 'slim-rails'
# gem 'twitter-bootswatch-rails', '~> 3.1.1'
# gem 'twitter-bootswatch-rails-helpers'
gem 'slack-api'
gem 'activerecord-import'
gem 'exception_notification'
gem 'slack-notifier'
gem 'delayed_job'
gem 'delayed_job_active_record'
gem 'daemons'
gem 'compass'
gem 'autoprefixer-rails', '~> 6.7.7.2'
gem 'bootstrap-tagsinput-rails'
gem 'draper'
gem 'pundit'
gem 'slappy', git: 'https://github.com/kozo002/slappy.git', branch: 'fix_respond'
gem 'nested_form'
gem 'addressable', require: 'addressable/uri'
gem 'toastr-rails'
gem 'natto'
gem 'config'
gem 'active_model_serializers'
gem 'non-stupid-digest-assets'
gem 'asset_sync'
gem 'fog-aws'
gem 'silencer'
gem 'foreman'
gem 'to_bool'
gem 'active_link_to'
gem 'grpc'
gem 'grpc-tools'

group :development, :test do

  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'rubocop'

  # N+1問題検出
  gem 'bullet'

  # Access an IRB console on exception pages or by using <%= console %> in views
  # 現時点では、better_errorsの方が使いやすい
#  gem 'web-console', '~> 2.0'
  # Debug
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
  gem 'quiet_assets'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-commands-rspec'

  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'pry-doc'
  gem 'pry-stack_explorer'
  gem 'tapp'

  # rspec
  gem 'rspec-rails', '~> 3.0.0'
  gem 'factory_girl_rails'
  gem 'guard'
  gem 'guard-rspec'
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'rspec_junit_formatter'

  # dummy data
  gem 'faker'

  gem 'database_cleaner'
  gem 'letter_opener'

  # Capistrano
  gem 'capistrano', '~> 3.6', '>= 3.6.1'
  gem 'capistrano-rails'
  gem 'capistrano-rbenv'
  gem 'capistrano-bundler'
  gem 'capistrano3-unicorn'
  gem 'capistrano3-delayed-job', '~> 1.0'
end

group :production, :staging do
  # Heroku用DB
  #gem 'pg'
  # ログ保存先変更、静的アセット Heroku 向けに調整
  #gem 'rails_12factor'
  gem 'newrelic_rpm'
  gem 'rollbar'
end
