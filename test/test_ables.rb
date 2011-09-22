require 'helper'

class AblesTest < Test::Unit::TestCase
  context "Class with Canable::Ables included" do
    setup do
      Canable.able_default = true

      @klass = Doc do
        include Canable::Ables
      end

      @resource = @klass.new
      @user     = mock('user')
    end

    should "default viewable_by? to true" do
      assert @resource.viewable_by?(@user)
    end

    should "default creatable_by? to true" do
      assert @resource.creatable_by?(@user)
    end

    should "default updatable_by? to true" do
      assert @resource.updatable_by?(@user)
    end

    should "default destroyable_by? to true" do
      assert @resource.destroyable_by?(@user)
    end

    should "raise error if able not defined" do
      assert_raises(NoMethodError) { @resource.publishable_by?(@user) }
    end

    should "default viewable_by? to true on the class level" do
      assert @klass.viewable_by?(@user)
    end

    should "default viewable_by? to true on the class level and ignores options" do
      assert @klass.viewable_by?(@user, :foo => "bar")
    end

    should "default able method ignores passed options" do
      assert @resource.viewable_by?(@user, :foo => "bar")
    end
  end

  context "Class with Canable::Ables included" do
    setup do
      Canable.able_default = false

      klass = Doc do
        include Canable::Ables
      end

      @user     = mock('user')
      @resource = klass.new
    end

    should "use the able_default setting" do
      assert ! @resource.viewable_by?(@user)
    end
  end

  context "Class with Canable::Ables included with overridden able_check" do
    setup do
      Canable.able_default = true

      klass = Doc do
        include Canable::Ables
        def self.able_check(user, able, options={})
          return user.name == "John" if able == :updatable
          default_able
        end
      end

      @resource = klass.new
      @john     = mock('user', :name => 'John')
      @steve    = mock('user', :name => 'Steve')
    end

    should "overridden able_check correctly using user" do
      assert @resource.viewable_by?(@steve)
      assert @resource.updatable_by?(@john)
      assert ! @resource.updatable_by?(@steve)
    end
  end

  context "Class with Canable::Ables included with overridden able_check" do
    setup do
      Canable.able_default = true

      klass = Doc do
        include Canable::Ables
        def self.able_check(user, able, options={})
          return false if options[:lockdown] == true
          default_able
        end
      end

      @resource = klass.new
      @user     = mock('user')
    end

    should "overridden able_check correctly using options" do
      assert @resource.viewable_by?(@user, :lockdown => false)
      assert ! @resource.viewable_by?(@user, :lockdown => true)
    end
  end
  
  context "Class that overrides an able method" do
    setup do
      Canable.able_default = true

      klass = Doc do
        include Canable::Ables
        
        def viewable_by?(user)
          user.name == 'John'
        end
      end
      
      @resource = klass.new
      @john     = mock('user', :name => 'John')
      @steve    = mock('user', :name => 'Steve')
    end
    
    should "use the overriden method and not default to true" do
      assert @resource.viewable_by?(@john)
      assert ! @resource.viewable_by?(@steve)
    end
  end

  context "Class that overrides an able method and accepts options" do
    setup do
      Canable.able_default = true

      klass = Doc do
        include Canable::Ables
        
        def viewable_by?(user, options={})
          user.name == 'John' && options[:day] == "Saturday"
        end
      end
      
      @resource = klass.new
      @john     = mock('user', :name => 'John')
    end
    
    should "use the options on the overriden method" do
      assert @resource.viewable_by?(@john, :day => "Saturday")
    end

    should "use the options on the overriden method" do
      assert ! @resource.viewable_by?(@john, :day => "Friday")
    end
    
  end
end