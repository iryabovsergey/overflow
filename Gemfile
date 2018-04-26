source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.1.4'
gem 'railties', '5.1.4'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
# Use Puma as the app server
gem 'puma', '~> 3.0'

# -----------Asset pipeline -------
gem 'sass-rails', '5.0.7' # Use SCSS for stylesheets
gem 'uglifier', '>= 1.3.0' # Use Uglifier as compressor for JavaScript assets
gem 'coffee-rails', '4.2.2' # Use CoffeeScript for .coffee assets and views
# ---------------------------------


# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
#
# Use ActiveModel has_secure_password
gem 'bcrypt' #, '3.1.7'
#gem 'bcrypt-ruby', '3.1.5'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'slim-rails', '3.1.3'

gem 'bootstrap-sass', '3.2.0.0'

#   Flexible authentication solution for Rails with Warde
gem 'devise', '4.4.0'

# DynamicForm holds a few helper methods to help you deal with your Rails3 models
gem 'dynamic_form', '1.1.4'

# Upload files in your Ruby applications
gem 'carrierwave', '1.2.1'

# support of autorization tokens for ajax quesries, with attached files
gem 'remotipart', '1.3.1'

gem 'nested_form', '~> 0.3.2'

gem 'gon'
gem 'skim'
gem 'pundit'
gem 'nenv'
gem 'active_model_serializers'
gem 'responders'
gem 'cancancan', '2.1.2'

gem 'private_pub'
gem 'thin'

gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-twitter'

gem 'doorkeeper'

gem 'active_model_serializers'
gem 'oj'
gem 'oj_mimic_json'


# lesson 17 ----------------------------
gem "sidekiq"
gem 'whenever'
gem 'sidetiq'
gem 'redis-throttle', git: 'git@github.com:andreareginato/redis-throttle.git'
gem 'sinatra', '>= 1.3.0', require: nil
gem 'delayed_job_active_record'
# ---------------------------------------

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem "sidekiq"
  gem 'rspec-rails', '3.6.1'
  gem 'factory_bot_rails', '4.8.2'
  gem 'capybara', '2.13.0'
  gem 'launchy'
  gem 'selenium-webdriver', '3.6.0'
  gem 'capybara-webkit', '1.14.0'
  gem 'database_cleaner', '1.6.1'
  gem 'rspec-retry', '0.5.5'
end

group :test do
  gem 'rails-controller-testing', '1.0.2'
  gem 'shoulda-matchers', '3.1.1'
  gem 'json_spec'
  gem 'simplecov'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
