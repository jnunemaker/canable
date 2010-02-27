require 'helper'

class CansTest < Test::Unit::TestCase
  context "Class with Canable::Cans included" do
    setup do
      klass = Doc do
        include Canable::Cans
      end
      
      @user = klass.create(:name => 'John')
    end

    context "can_view?" do
      should "be true if resource is viewable_by?" do
        resource = mock('resource', :viewable_by? => true)
        assert @user.can_view?(resource)
      end

      should "be false if resource is not viewable_by?" do
        resource = mock('resource', :viewable_by? => false)
        assert ! @user.can_view?(resource)
      end

      should "be false if resource is blank" do
        assert ! @user.can_view?(nil)
        assert ! @user.can_view?('')
      end
    end

    context "can_create?" do
      should "be true if resource is creatable_by?" do
        resource = mock('resource', :creatable_by? => true)
        assert @user.can_create?(resource)
      end

      should "be false if resource is not creatable_by?" do
        resource = mock('resource', :creatable_by? => false)
        assert ! @user.can_create?(resource)
      end

      should "be false if resource is blank" do
        assert ! @user.can_create?(nil)
        assert ! @user.can_create?('')
      end
    end

    context "can_update?" do
      should "be true if resource is updatable_by?" do
        resource = mock('resource', :updatable_by? => true)
        assert @user.can_update?(resource)
      end

      should "be false if resource is not updatable_by?" do
        resource = mock('resource', :updatable_by? => false)
        assert ! @user.can_update?(resource)
      end

      should "be false if resource is blank" do
        assert ! @user.can_update?(nil)
        assert ! @user.can_update?('')
      end
    end

    context "can_destroy?" do
      should "be true if resource is destroyable_by?" do
        resource = mock('resource', :destroyable_by? => true)
        assert @user.can_destroy?(resource)
      end

      should "be false if resource is not destroyable_by?" do
        resource = mock('resource', :destroyable_by? => false)
        assert ! @user.can_destroy?(resource)
      end

      should "be false if resource is blank" do
        assert ! @user.can_destroy?(nil)
        assert ! @user.can_destroy?('')
      end
    end
  end
end