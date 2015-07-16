# Encoding: UTF-8

source 'https://rubygems.org'

group :development do
  gem 'yard-chef'
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-kitchen'
end

group :test do
  gem 'rake'
  gem 'cane'
  gem 'countloc'
  gem 'rubocop'
  gem 'foodcritic'
  # TODO: guard-foodcritic has a dep conflict with Berkshelf 3
  # gem 'guard-foodcritic'
  gem 'rspec'
  gem 'chefspec'
  gem 'simplecov'
  gem 'simplecov-console'
  gem 'coveralls'
  gem 'fauxhai'
  gem 'win32-service'
  gem 'win32-eventlog'
  gem 'test-kitchen'
  gem 'kitchen-digitalocean'
  gem 'kitchen-vagrant'
  gem 'kitchen-ec2'
  
end

group :integration do
  gem 'serverspec'
  gem 'cucumber'
end

group :deploy do
  gem 'stove'
end

group :production do
  gem 'chef'
  gem 'berkshelf'
  gem 'omnijack'
end
