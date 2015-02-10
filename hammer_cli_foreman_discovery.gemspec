# -*- coding: utf-8 -*-
$:.unshift(File.expand_path('../lib', __FILE__))

# Maintain your gem's version:
require "hammer_cli_foreman_discovery/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "hammer_cli_foreman_discovery"
  s.version     = HammerCLIForemanDiscovery.version
  s.authors     = ["Ohad Levy", "Ori Rabin"]
  s.license     = "GPL-3"
  s.email       = ["ohadlevy@gmail.com"]
  s.homepage    = "https://github.com/theforeman/hammer-cli-foreman-discovery"
  s.summary     = "Foreman CLI plugin for managing discovery hosts in foreman"
  s.description = <<DESC
Contains the code for managing host discovery in foreman(results and progress) in the Hammer CLI.
DESC

  s.files = Dir['{lib,locale}/**/*', 'README*']
  s.extra_rdoc_files = Dir['README*']
  s.require_paths = ["lib"]

  s.add_dependency "hammer_cli_foreman", ">= 0.1.2"
  s.add_development_dependency 'rake'
end
