source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.0'
# Use postgres as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development

gem 'rack-cors', :require => 'rack/cors'

group :development do
  gem 'faker'
end

group :development, :test do
  gem 'debugger'
end

group :test do
  gem 'nokogiri'
  gem 'mocha'
end

# Use unicorn as the app server
gem 'unicorn'

gem 'capistrano',  '~> 3.1'
gem 'capistrano-rails', '~> 1.1'
gem 'capistrano-bundler', '~> 1.1', require: false
