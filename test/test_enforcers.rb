require 'helper'

class EnforcersTest < Test::Unit::TestCase
  context "Including Canable::Enforcers in a class" do
    setup do
      klass = Class.new do
        include Canable::Enforcers
        attr_accessor :current_user, :article, :enforce_calls

        # Overriding example
        def can_update?(resource)
          return false if current_user && current_user.banned?
          super
        end

        def show
          enforce_view_permission(article)
        end

        def update
          enforce_update_permission(article)
        end

        def edit
          enforce_update_permission(article, "You Can't Edit This")
        end

        def handle_enforce(object, permission)
          @enforce_calls ||= []
          @enforce_calls << [object, permission]
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

    should "raise error whenever current_user nil" do
      @controller.current_user = nil
      assert_raises(Canable::Transgression) { @controller.show }
    end

    should "be able to override can_xx? method" do
      @user.expects(:banned?).returns(true)
      assert_raises(Canable::Transgression) { @controller.update }
    end

    should "pass message around the stack" do
      @controller.current_user = nil
      begin
        @controller.edit
      rescue Canable::Transgression => e
        assert_equal e.message, "You Can't Edit This"
      end
    end

    should "notify observers of the enforcer call" do
      @user.expects(:can_view?).with(@article).returns(true)
      @user.expects(:can_update?).with(@article).returns(true)
      @user.expects(:banned?).returns(false)

      @controller.show
      @controller.update

      calls = @controller.enforce_calls
      assert_includes(calls, [:view, @article])
      assert_includes(calls, [:update, @article])
    end
  end
end
