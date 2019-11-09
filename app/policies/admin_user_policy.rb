# frozen_string_literal: true

class AdminUserPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
  end

  alias_rule :set_role?, to: :update?

  def update?
    if record.root? && !user.root?
      false
    else
      super
    end
  end

  private

  def section_name
    if user.id == record.id
      :'AdminUser/Self'
    else
      :AdminUser
    end
  end
end
