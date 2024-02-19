source "https://rubygems.org"

gemspec

gem 'gettext', '>= 3.1.3', '< 4.0.0'
gem 'rake', '~> 13.0'
gem 'hammer_cli_foreman', github: 'theforeman/hammer-cli-foreman', branch: 'master'

group :test do
  gem 'thor'
  gem 'minitest', '~> 5.18'
  gem 'minitest-spec-context'
  gem 'simplecov'
  gem 'mocha'
  gem 'ci_reporter', '>= 1.6.3', "< 2.0.0", :require => false
  gem 'rubocop', '~> 1.57.0'
  gem 'rubocop-minitest', '~> 0.9.0'
  gem 'rubocop-performance', '~> 1.5.2'
  gem 'rubocop-rails', '~> 2.7.1'
end

# load local gemfile
local_gemfile = File.join(File.dirname(__FILE__), 'Gemfile.local')
self.instance_eval(Bundler.read_file(local_gemfile)) if File.exist?(local_gemfile)
