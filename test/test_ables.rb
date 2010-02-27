require 'helper'

class AblesTest < Test::Unit::TestCase
  context "Class with Canable::Ables included" do
    setup do
      klass = Doc do
        include Canable::Ables
      end

      @resource = klass.new
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
  end
  
  context "Class that overrides an able method" do
    setup do
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
end