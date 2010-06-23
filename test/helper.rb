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
end

MongoMapper.connection = Mongo::Connection.new('127.0.0.1', 27017)
MongoMapper.database = 'test'