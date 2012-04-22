# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "canable/version"

Gem::Specification.new do |s|
  s.name        = "canable"
  s.version     = Canable::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["John Nunemaker"]
  s.email       = ["nunemaker@gmail.com"]
  s.homepage    = "http://jnunemaker.github.com/canable/"
  s.summary     = %Q{Simple permissions that I have used on my last several projects so I figured it was time to abstract and wrap up into something more easily reusable.}
  s.description = %Q{Simple permissions that I have used on my last several projects so I figured it was time to abstract and wrap up into something more easily reusable.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
