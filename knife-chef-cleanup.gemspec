$LOAD_PATH.push File.expand_path("../lib", __FILE__)
require "knife-chef-cleanup/version"

Gem::Specification.new do |s|
  s.name        = "knife-chef-cleanup"
  s.version     = Knife::CookbookCleaner::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = "Brent Montague"
  s.email       = "brent@bmontague.com"
  s.homepage    = "https://github.com/bigbam505/knife-chef-cleanup"
  s.summary     = "Chef Knife plugin to help cleanup outdated cookbooks"
  s.description = "A knife plugin to see cookbooks that can be deleted"

  s.files         = `git ls-files`.split("\n")
  s.require_paths = ["lib"]

  s.add_dependency "chef", "> 0.10.10"

  s.add_development_dependency "bundler", "~> 1.6"
  s.add_development_dependency "rake"
  s.add_development_dependency "rubocop"
end
