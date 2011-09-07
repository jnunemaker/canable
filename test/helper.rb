require 'test/unit'

gem 'mocha', '~> 0.9.8'
gem 'shoulda', '~> 2.10.2'
gem 'mongo_mapper'

require 'mocha'
require 'shoulda'
require 'mongo_mapper'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'canable'

class Test::Unit::TestCase
  def Doc(name=nil, &block)
    klass = Struct.new(:name)
    klass.class_eval(&block) if block_given?
    klass
  end
end
