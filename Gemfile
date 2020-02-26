# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.4.3'

gem 'bootsnap', '>= 1.1.0', require: false
gem 'pg'
gem 'puma', '~> 3.11'
gem 'rails', '~> 5.2.3'

gem 'redis'
gem 'redis-namespace'
gem 'redis-rails'

gem 'dotenv-rails'

group :development, :test do
  gem 'pry', '~> 0.12.2'

  gem 'database_cleaner'
  gem 'factory_bot'
  gem 'faraday'
  gem 'rspec'
  gem 'rspec-rails'

  gem 'rubocop', '~> 0.75.1', require: false
  gem 'rubocop-performance'
  gem 'rubocop-rails'
  gem 'rubocop-rails_config'
  gem 'rubocop-rspec'

  gem 'simplecov'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
