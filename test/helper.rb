require 'test/unit'

gem 'mocha', '0.9.8'
gem 'shoulda', '2.10.2'
gem 'mongo_mapper', '0.7'

require 'mocha'
require 'shoulda'
require 'mongo_mapper'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'canable'

class Test::Unit::TestCase
end

def Doc(name=nil, &block)
  klass = Class.new do
    include MongoMapper::Document
    set_collection_name "test#{rand(20)}"

    if name
      class_eval "def self.name; '#{name}' end"
      class_eval "def self.to_s; '#{name}' end"
    end
  end

  klass.class_eval(&block) if block_given?
  klass.collection.remove
  klass
end

test_dir = File.expand_path(File.dirname(__FILE__) + '/../tmp')
FileUtils.mkdir_p(test_dir) unless File.exist?(test_dir)

MongoMapper.connection = Mongo::Connection.new('127.0.0.1', 27017, {:logger => Logger.new(test_dir + '/test.log')})
MongoMapper.database = 'test'