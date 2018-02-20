source 'https://rubygems.org'
ruby '2.4.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.1.4'
gem 'rake', '< 11'

# select DB for local server
#gem 'mysql2'
# gem 'sqlite3', :group => :development
gem 'mysql2', '~> 0.3.20'


# Use SCSS for stylesheets
gem 'sass', '~> 3.5.2'
gem 'sass-rails'

# easy to write a form
gem 'bootstrap', '~> 4.0.0.beta2.1'
#gem 'simple_form' #代替案

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', '0.12.3', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.0' TODO
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
gem 'devise-i18n'
gem 'devise-i18n-views'

# admin pages
gem 'rails_admin'

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
gem 'seed-fu'
gem 'active_hash'
gem 'dotenv-rails'
gem 'rails_autolink'
gem 'http'
gem 'whenever', require: false
gem 'carrierwave'
gem 'rmagick', require: false
gem 'rails4-autocomplete'
gem 'slim-rails'
gem 'slack-api'
gem 'activerecord-import'
gem 'exception_notification'
gem 'slack-notifier'
gem 'delayed_job'
gem 'delayed_job_active_record'
gem 'daemons'
gem 'autoprefixer-rails', '~> 6.7.7.2'
gem 'draper', '>= 3.0.0.pre1'
gem 'pundit'
gem 'nested_form'
gem 'addressable', require: 'addressable/uri'
gem 'toastr-rails'
gem 'natto'
gem 'config'
gem 'active_model_serializers'
gem 'non-stupid-digest-assets'
gem 'fog-aws'
gem 'silencer'
gem 'foreman'
gem 'to_bool'
gem 'active_link_to'
gem 'grpc'
gem 'grpc-tools'
gem 'google-protobuf', '3.4.0.2'
gem 'email_validator'
gem 'webpacker', '~> 3.0'
gem 'mini_mime'
gem 'hashie'
gem 'faraday', '~> 0.12.1'
gem 'asset_sync', '~> 2.4.0'
gem 'acts_as_list'

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
  gem 'better_errors', '~> 2.4.0'
  gem 'binding_of_caller'
  gem 'meta_request'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-commands-rspec'

  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'pry-doc'
  gem 'pry-stack_explorer'
  gem 'tapp'

  # rspec
  gem 'rspec-rails', '~> 3.5.0.beta'
  gem 'factory_girl_rails'
  gem 'capybara', '~> 2.15.4'
  gem 'selenium-webdriver', '~> 3.6.0'
  gem 'rspec_junit_formatter'
  gem 'rails-controller-testing'

  # dummy data
  gem 'faker'

  gem 'database_cleaner'
  gem 'letter_opener'
  gem 'letter_opener_web'

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
