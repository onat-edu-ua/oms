class SetRoleForm < ApplicationForm
  attribute :role
  attr_accessor :model, :initiator

  validates :model, :initiator, presence: true
  validates :role, inclusion: { in: AdminUser.allowed_roles }
  validate :validate_root_role

  def _save
    model.update!(role: role)
  end

  private

  def validate_root_role
    return if role.blank? || model.nil? || initiator.nil?

    if set_role_to_root? && !initiator.root?
      errors.add(:role, "not root admin user can't set root role to someone")
    end

    if !set_role_to_root? && model.root? && !initiator.root?
      errors.add(:role, "not root admin user can't remove root role from another admin user")
    end
  end

  def set_role_to_root?
    role&.to_sym == PunditRoles::Configuration.root_role.to_sym
  end
end
