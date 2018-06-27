# == Schema Information
#
# Table name: students
#
#  id               :bigint(8)        not null, primary key
#  allowed_services :integer          default([]), is an Array
#  first_name       :string           not null
#  last_name        :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

FactoryBot.define do
  factory :student do
  end
end
