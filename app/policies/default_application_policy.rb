# frozen_string_literal: true

class DefaultApplicationPolicy < ApplicationPolicy
  def read?
    no_policy_class!
  end

  def create?
    no_policy_class!
  end

  def update?
    no_policy_class!
  end

  def destroy?
    no_policy_class!
  end
end
