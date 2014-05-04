require 'minitest/autorun'
require 'mocha/setup'
require 'shoulda'
require 'active_support/all'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'canable'

class Minitest::Test
  def Doc(name=nil, &block)
    klass = Struct.new(:name)
    klass.class_eval(&block) if block_given?
    klass
  end
end
