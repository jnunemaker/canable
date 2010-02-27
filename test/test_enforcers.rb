require 'helper'

class EnforcersTest < Test::Unit::TestCase
  context "Including Canable::Enforcers in a class" do
    setup do
      klass = Class.new do
        include Canable::Enforcers
        attr_accessor :current_user, :article

        def show
          enforce_view_permission(article)
        end
      end

      @article                 = mock('article')
      @user                    = mock('user')
      @controller              = klass.new
      @controller.article      = @article
      @controller.current_user = @user
    end

    should "not raise error if can" do
      @user.expects(:can_view?).with(@article).returns(true)
      assert_nothing_raised { @controller.show }
    end

    should "raise error if cannot" do
      @user.expects(:can_view?).with(@article).returns(false)
      assert_raises(Canable::Transgression) { @controller.show }
    end
  end
end