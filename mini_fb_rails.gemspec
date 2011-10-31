# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "mini_fb_rails/version"

Gem::Specification.new do |s|
  s.name        = "mini_fb_rails"
  s.version     = MiniFbRails::VERSION
  s.authors     = ["Marc Essindi"]
  s.email       = ["marc.essindi@dunkelbraun.com"]
  s.homepage    = "https://github.com/dunkelbraun/mini_fb_rails"
  s.summary     = "Extending MiniFB to provide Facebook Connect Verification Filters for Rails."
  
  s.rubyforge_project = "mini_fb_rails"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "rails", ">= 3.0.3"
  s.add_dependency "mini_fb", ">= 1.1.7"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "mocha"

end
