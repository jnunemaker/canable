module Canable
  # Module that holds all the can_action? methods.
  module Cans; end

  # Module that holds all the [method]able_by? methods.
  module Ables
    def self.included(klass)
      klass.instance_eval <<-EOM
        def able_check(user, able, options={})
          default_able(able)
        end
        def default_able(able=nil)
          #{Canable.able_default}
        end
      EOM
      Canable.ables.each do |able|
        klass.instance_eval <<-EOM
          def #{able}_by?(*args)
            user, options = args
            able_check(user, :#{able}, options || {})
          end
        EOM
        klass.class_eval <<-EOM
          def #{able}_by?(*args)
            user, options = args
            self.class.able_check(user, :#{able}, options || {})
          end
        EOM
      end
    end
  end

  # Module that holds all the enforce_[action]_permission methods for use in controllers.
  module Enforcers
    def self.included(controller)
      controller.class_eval do
        Canable.cans.each do |can|
          helper_method "can_#{can}?" if controller.respond_to?(:helper_method)
          hide_action   "can_#{can}?" if controller.respond_to?(:hide_action)
        end
        
        private
        
          def transgression_message(options)
            return options if options.is_a?(String)
            return options[:message] if options.is_a?(Hash)
            ""
          end
      end
    end
  end

  # Exception that gets raised when permissions are broken for whatever reason.
  class Transgression < StandardError; end
  
  # The default value for all able methods
  @able_default = true
  
  # Default actions to an empty hash.
  @actions = {}

  # Returns hash of actions that have been added.
  #   {:view => :viewable, ...}
  def self.actions
    @actions
  end

  def self.cans
    actions.keys
  end

  def self.ables
    actions.values
  end
  
  def self.able_default
    @able_default
  end

  def self.able_default=(value)
    @able_default = value
  end

  # Adds an action to actions and the correct methods to can and able modules.
  #
  #   @param [Symbol] can_method The name of the can_[action]? method.
  #   @param [Symbol] resource_method The name of the [resource_method]_by? method.
  def self.add(can, able)
    @actions[can] = able
    add_can_method(can, able)
    add_enforcer_method(can)
  end

  private
  
    def self.add_can_method(can, able)
      Cans.module_eval <<-EOM
        def can_#{can}?(*args)
          resource, options = args
          return false if resource.blank?
          resource.method(:#{able}_by?).arity == 1 ? resource.#{able}_by?(self) : resource.#{able}_by?(self, options)
        end
      EOM
    end
    
    def self.add_enforcer_method(can)
      Enforcers.module_eval <<-EOM
        def can_#{can}?(*args)
          resource, options = args
          return false if current_user.blank?
          current_user.can_#{can}?(resource, options)
        end
        
        def enforce_#{can}_permission(*args)
          resource, options = args
          unless method(:can_#{can}?).arity == 1 ? can_#{can}?(resource) : can_#{can}?(resource, options)
            raise(Canable::Transgression, transgression_message(options))
          end
        end
        
        private :enforce_#{can}_permission
      EOM
    end
end

Canable.add(:view,    :viewable)
Canable.add(:create,  :creatable)
Canable.add(:update,  :updatable)
Canable.add(:destroy, :destroyable)