# frozen_string_literal: true

class StringPresenceType < ActiveRecord::Type::String
  def cast_value(value)
    if value.is_a?(String) && value.blank?
      nil
    else
      super(value)
    end
  end
end

ActiveRecord::Type.register :string_presence, StringPresenceType
