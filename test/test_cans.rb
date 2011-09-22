require 'helper'

class CansTest < Test::Unit::TestCase
  context "Class with Canable::Cans included" do
    setup do
      Canable.able_default = true

      can_class = Doc do
        include Canable::Cans
      end
      able_class = Doc do
        include Canable::Ables
      end
      
      @resource = able_class.new
      @user = can_class.new(:name => 'John')
    end

    context "can_view?" do
      should "be true if resource is viewable_by?" do
        @resource.expects(:viewable_by?).returns(true)
        assert @user.can_view?(@resource)
      end

      should "be false if resource is not viewable_by?" do
        @resource.expects(:viewable_by?).returns(false)
        assert ! @user.can_view?(@resource)
      end

      should "be false if resource is blank" do
        assert ! @user.can_view?(nil)
        assert ! @user.can_view?('')
      end
    end

    context "can_create?" do
      should "be true if resource is creatable_by?" do
        @resource.expects(:creatable_by?).returns(true)
        assert @user.can_create?(@resource)
      end

      should "be false if resource is not creatable_by?" do
        @resource.expects(:creatable_by?).returns(false)
        assert ! @user.can_create?(@resource)
      end

      should "be false if resource is blank" do
        assert ! @user.can_create?(nil)
        assert ! @user.can_create?('')
      end
    end

    context "can_update?" do
      should "be true if resource is updatable_by?" do
        @resource.expects(:updatable_by?).returns(true)
        assert @user.can_update?(@resource)
      end

      should "be false if resource is not updatable_by?" do
        @resource.expects(:updatable_by?).returns(false)
        assert ! @user.can_update?(@resource)
      end

      should "be false if resource is blank" do
        assert ! @user.can_update?(nil)
        assert ! @user.can_update?('')
      end
    end

    context "can_destroy?" do
      should "be true if resource is destroyable_by?" do
        @resource.expects(:destroyable_by?).returns(true)
        assert @user.can_destroy?(@resource)
      end

      should "be false if resource is not destroyable_by?" do
        @resource.expects(:destroyable_by?).returns(false)
        assert ! @user.can_destroy?(@resource)
      end

      should "be false if resource is blank" do
        assert ! @user.can_destroy?(nil)
        assert ! @user.can_destroy?('')
      end
    end
  end
end