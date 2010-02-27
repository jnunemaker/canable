require 'helper'

class TestCanable < Test::Unit::TestCase
  context "Canable" do
    should "have view action by default" do
      assert_equal :viewable, Canable.actions[:view]
    end

    should "have create action by default" do
      assert_equal :creatable, Canable.actions[:create]
    end

    should "have update action by default" do
      assert_equal :updatable, Canable.actions[:update]
    end

    should "have destroy action by default" do
      assert_equal :destroyable, Canable.actions[:destroy]
    end
    
    should "be able to add another action" do
      Canable.add(:publish, :publishable)
      assert_equal :publishable, Canable.actions[:publish]
    end
  end
end
