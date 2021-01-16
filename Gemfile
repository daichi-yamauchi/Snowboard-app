source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

gem 'rails', '~> 6.0.3', '>= 6.0.3.4'

gem 'active_storage_validations'
gem 'aws-sdk-rails', '~> 3'
gem 'aws-sdk-s3', require: false
gem 'bcrypt', '~> 3.1.7'
gem 'bootsnap', '>= 1.4.2', require: false
gem 'faker', '2.1.2'
gem 'image_processing'
gem 'jbuilder', '~> 2.7'
gem 'mini_magick'
gem 'puma', '~> 4.1'
gem 'sass-rails', '>= 6'
gem 'turbolinks', '~> 5'
gem 'webpacker', '~> 4.0'
gem 'will_paginate', '3.1.8'
gem 'will_paginate-bootstrap4'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'pry-byebug'  # デバッグを実施(Ruby 2.0以降で動作する)
  gem 'pry-doc'     # methodを表示
  gem 'pry-rails'   # rails console(もしくは、rails c)でirbの代わりにpryを使われる
  gem 'pry-stack_explorer' # スタックをたどれる
  gem 'sqlite3', '~> 1.4'
end

group :development do
  gem 'listen', '~> 3.2'
  gem 'overcommit'
  gem 'rubocop', require: false
  gem 'rubocop-config-prettier'
  gem 'rubocop-config-rufo'
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec'
  gem 'rufo'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara'
  gem 'factory_bot_rails'
  gem 'rack_session_access'
  gem 'rails-controller-testing'
  gem 'rspec-rails', '~> 4.0.1'
  gem 'selenium-webdriver'
  gem 'spring-commands-rspec'
  gem 'webdrivers'
end

group :production do
  gem 'pg', '1.1.4'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
