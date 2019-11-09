# frozen_string_literal: true

module ActiveAdmin
  class PagePolicy < ::ApplicationPolicy
    class Scope < ::ApplicationPolicy::Scope
    end

    SECTION_NAMES = {
      # Dashboard: :Dashboard
    }.freeze

    private

    def section_name
      page_name = record.name.to_sym
      SECTION_NAMES.fetch(page_name, page_name).to_sym
    end
  end
end
