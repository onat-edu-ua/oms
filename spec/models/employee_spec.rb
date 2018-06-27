# == Schema Information
#
# Table name: employees
#
#  id               :bigint(8)        not null, primary key
#  allowed_services :integer          default([]), is an Array
#  first_name       :string           not null
#  last_name        :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'rails_helper'

RSpec.describe Employee, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
