source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.0.rc1'
# Use mysql as the database for Active Record
gem 'mysql2', '>= 0.3.13', '< 0.5'

# optimization
gem 'rack-mini-profiler', require: false

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
#gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
gem 'capistrano'
gem 'capistrano-rvm'
gem 'capistrano-rails'
gem 'capistrano-bundler'
gem 'capistrano3-puma'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'better_errors', '~> 2.1', '>= 2.1.1' # better errors
    # Access an IRB console on exception pages or by using <%= console %> in views
end

group :development, :production do
  gem 'bootstrap' # bootstrap for layout
  gem 'roo' # import from csv files
end

group :production, :development, :test do
	gem 'devise' # user logigng in
end

group :test do
	gem 'rspec-rails'
	gem 'capybara'
	gem 'spring-commands-rspec' # testing speed up
	gem 'factory_bot_rails'
end

gem 'web-console', '~> 2.0', groups: [:development]

gem 'autoprefixer-rails'
gem 'bootstrap-generators'

# for-api-scraoer
gem 'rest-client', '~> 1.8'

# better text fields
gem 'ckeditor'

# image processing
gem 'paperclip'

# password encoding
gem 'bcrypt'

# translate reviews to en
gem 'easy_translate'

# icons from font awesome
gem 'font-awesome-sass', '~> 5.0.13'

# meta tags
gem 'meta-tags'

# error pages
gem 'gaffe'

# scraping
gem 'watir'

# code analyze
gem 'rubocop'

gem "haml"