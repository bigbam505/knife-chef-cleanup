# frozen_string_literal: true
$LOAD_PATH.push File.expand_path("../lib", __FILE__)
require "knife-chef-inventory/version"

Gem::Specification.new do |s|
  s.name        = "knife-chef-inventory"
  s.version     = Knife::ChefInventory::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = "Brent Montague"
  s.email       = "brent@bmontague.com"
  s.homepage    = "https://github.com/brentm5/knife-chef-inventory"
  s.summary     = "Chef Knife plugin to help cleanup outdated cookbooks"
  s.description = "A knife plugin to see cookbooks that can be deleted"

  s.license     = "Apache License, v2.0"

  s.files         = `git ls-files`.split("\n")
  s.require_paths = ["lib"]

  s.add_dependency "chef", "<= 12.11.18"

  s.add_development_dependency "bundler", "~> 1.6"
  s.add_development_dependency "rake", "~> 11.1"
  s.add_development_dependency "rubocop", "~> 0.38"
  s.add_development_dependency "github_changelog_generator", "~> 1.13"
end
