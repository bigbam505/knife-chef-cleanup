# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)
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

  s.required_ruby_version = "~> 2.3"

  s.add_dependency "chef", ">= 12.11", "< 16"
end
