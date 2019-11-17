# == Schema Information
#
# Table name: employees
#
#  id              :bigint(8)        not null, primary key
#  email           :string
#  first_name      :string           not null
#  inn             :string
#  last_name       :string           not null
#  middle_name     :string
#  passport_number :string
#  phone_number    :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  employees_inn_key              (inn) UNIQUE
#  employees_passport_number_key  (passport_number) UNIQUE
#

class Employee < ApplicationRecord
  include ActsAsLoginable

  attribute :inn, :string_presence
  attribute :passport_number, :string_presence

  validates :first_name, :last_name, presence: true
  validates :inn, :passport_number, uniqueness: true, allow_blank: true

  def full_name
    "#{first_name} #{last_name}"
  end

  def display_name
    "#{id} | #{full_name}"
  end
end
