# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

gem 'gettext', '>= 3.1.3', '< 4.0.0'
gem 'rake', '~> 13.0'

group :test do
  gem 'minitest', '~> 5.18'
  gem 'minitest-spec-context'
  gem 'mocha'
  gem 'simplecov'
  gem 'theforeman-rubocop', '~> 0.1.0'
  gem 'thor'
end

# load local gemfile
local_gemfile = File.join(File.dirname(__FILE__), 'Gemfile.local')
instance_eval(Bundler.read_file(local_gemfile)) if File.exist?(local_gemfile)
