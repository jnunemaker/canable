module Canable
  Version = '0.1.1'

  # Module that holds all the can_action? methods.
  module Cans; end

  # Module that holds all the [method]able_by? methods.
  module Ables; end

  # Module that holds all the enforce_[action]_permission methods for use in controllers.
  module Enforcers
    def self.included(controller)
      controller.class_eval do
        Canable.cans.each do |can|
          helper_method "can_#{can}?" if controller.respond_to?(:helper_method)
          hide_action   "can_#{can}?" if controller.respond_to?(:hide_action)
        end
      end
    end
  end

  # Exception that gets raised when permissions are broken for whatever reason.
  class Transgression < StandardError; end

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

  # Adds an action to actions and the correct methods to can and able modules.
  #
  #   @param [Symbol] can_method The name of the can_[action]? method.
  #   @param [Symbol] resource_method The name of the [resource_method]_by? method.
  def self.add(can, able)
    @actions[can] = able
    add_can_method(can, able)
    add_able_method(able)
    add_enforcer_method(can)
  end

  private
    def self.add_can_method(can, able)
      Cans.module_eval <<-EOM
        def can_#{can}?(resource)
          return false if resource.blank?
          resource.#{able}_by?(self)
        end
      EOM
    end

    def self.add_able_method(able)
      Ables.module_eval <<-EOM
        def #{able}_by?(user)
          true
        end
      EOM
    end

    def self.add_enforcer_method(can)
      Enforcers.module_eval <<-EOM
        def can_#{can}?(resource)
          current_user.can_#{can}?(resource)
        end

        def enforce_#{can}_permission(resource)
          raise Canable::Transgression unless can_#{can}?(resource)
        end
        private :enforce_#{can}_permission
      EOM
    end
end

Canable.add(:view,    :viewable)
Canable.add(:create,  :creatable)
Canable.add(:update,  :updatable)
Canable.add(:destroy, :destroyable)