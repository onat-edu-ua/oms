# == Schema Information
#
# Table name: services
#
#  id         :bigint(8)        not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Service < ApplicationRecord
  module CONST
    EMAIL = 1
    EDUROAM = 2

    freeze
  end

  scope :ordered, -> do
    order(name: :asc)
  end
end
