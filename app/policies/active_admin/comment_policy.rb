# frozen_string_literal: true

module ActiveAdmin
  class CommentPolicy < ::ApplicationPolicy
    section 'ActiveAdmin/Comment'

    class Scope < ::ApplicationPolicy::Scope
    end
  end
end
