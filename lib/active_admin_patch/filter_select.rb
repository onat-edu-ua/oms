# frozen_string_literal: true

module ActiveAdminPatch
  module FilterSelect
    def filter_select(name, options = {})
      opts = options.dup
      opts[:as] ||= :select
      opts[:input_html] ||= {}
      opts[:input_html][:class] ||= :chosen
      opts[:collection] = [['Yes', true], ['No', false]] if opts.delete(:boolean)

      filter name, opts
    end
  end
end

ActiveAdmin::ResourceDSL.include ActiveAdminPatch::FilterSelect
