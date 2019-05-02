# frozen_string_literal: true

class ApplicationPolicy < PunditRoles::RolesPolicy
  class Scope < PunditRoles::RolesPolicy::Scope
  end

  class_attribute :logger, instance_writer: false
  self.logger = Rails.logger

  abstract
  allowed_rules :read, :create, :update, :destroy, :perform
  define_allowed_rules
  alias_rule :index?, :show?, to: :read?
  alias_rule :new?, to: :create?
  alias_rule :edit?, to: :update?
  alias_rule :remove?, to: :destroy?
  alias_rule :batch_destroy?, to: :destroy?

  private

  def user_root?
    user.root?
  end

  def user_roles
    [user.role]
  end

  def development?
    Rails.env.development?
  end

  def production?
    Rails.env.production?
  end

  def test?
    Rails.env.test?
  end
end
