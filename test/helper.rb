require 'test/unit'
require 'mocha'
require 'shoulda'
require 'active_support/all'

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
