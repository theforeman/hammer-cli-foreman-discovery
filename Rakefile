# frozen_string_literal: true

require 'rake/testtask'
require 'bundler/gem_tasks'

Rake::TestTask.new do |t|
  t.libs.push "lib"
  t.test_files = Dir.glob('test/**/*_test.rb')
  t.verbose = true
end

namespace :pkg do
  desc 'Generate package source gem'
  task :generate_source => :build
end

require "hammer_cli_foreman_discovery/version"
require "hammer_cli_foreman_discovery/i18n"
require "hammer_cli/i18n/find_task"
HammerCLI::I18n::FindTask.define(HammerCLIForemanDiscovery::I18n::LocaleDomain.new, HammerCLIForemanDiscovery.version.to_s)

begin
  require 'rubocop/rake_task'
rescue LoadError
  # RuboCop is optional
  task default: :test
else
  RuboCop::RakeTask.new
  task default: %i[rubocop test]
end
