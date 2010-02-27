require 'rubygems'
require 'rake'

require File.dirname(__FILE__) + '/lib/canable'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name        = "canable"
    gem.summary     = %Q{Simple permissions that I have used on my last several projects so I figured it was time to abstract and wrap up into something more easily reusable.}
    gem.description = %Q{Simple permissions that I have used on my last several projects so I figured it was time to abstract and wrap up into something more easily reusable.}
    gem.email       = "nunemaker@gmail.com"
    gem.homepage    = "http://github.com/jnunemaker/canable"
    gem.authors     = ["John Nunemaker"]
    gem.version     = Canable::Version
    gem.add_development_dependency "shoulda", "2.10.2"
    gem.add_development_dependency "mongo_mapper", "0.7"
    gem.add_development_dependency "mocha", "0.9.8"
    gem.add_development_dependency "yard", ">= 0"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.ruby_opts << '-rubygems'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :test => :check_dependencies
task :default => :test

begin
  require 'yard'
  YARD::Rake::YardocTask.new
rescue LoadError
  task :yardoc do
    abort "YARD is not available. In order to run yardoc, you must: sudo gem install yard"
  end
end
