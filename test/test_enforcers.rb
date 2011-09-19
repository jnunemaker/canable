require 'helper'

class EnforcersTest < Test::Unit::TestCase
  context "Including Canable::Enforcers in a class" do
    setup do
      klass = Class.new do
        include Canable::Enforcers
        attr_accessor :current_user, :article

        # Overriding example
        def can_update?(resource)
          return false if current_user && current_user.banned?
          super
        end
        
        # Override that accepts options
        def can_destroy?(resource, options={})
          return true if options && options[:secret] == "123"
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
        
        def destroy(options={})
          enforce_destroy_permission(article, options)
        end
      end

      @article                 = mock('article')
      @user                    = mock('user')
      @controller              = klass.new
      @controller.article      = @article
      @controller.current_user = @user
    end

    should "not raise error if can" do
      @user.expects(:can_view?).with(@article, nil).returns(true)
      assert_nothing_raised { @controller.show }
    end

    should "raise error if cannot" do
      @user.expects(:can_view?).with(@article, nil).returns(false)
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
    
    should "be able to define overridden can_xx? method with options" do
      @user.expects(:can_destroy?).with(@article, {}).returns(false)
      assert_raises(Canable::Transgression) { @controller.destroy }
    end
    
    should "be able to use options on overridden can_xx? method" do
      assert_nothing_raised { @controller.destroy(:secret => "123") }
    end
    
    should "be able to pass a transgression message in the options hash" do
      @controller.current_user = nil
      begin
        @controller.destroy(:message => "You Can't Edit This")
      rescue Canable::Transgression => e
        assert_equal e.message, "You Can't Edit This"
      end
    end
  end
end