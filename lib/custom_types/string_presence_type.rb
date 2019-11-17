# frozen_string_literal: true

class StringPresenceType < ActiveRecord::Type::String
  def cast_value(value)
    value = value.presence if value.is_a?(String)
    super(value)
  end
end

ActiveRecord::Type.register :string_presence, StringPresenceType
