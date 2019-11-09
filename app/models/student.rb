# == Schema Information
#
# Table name: students
#
#  id              :bigint(8)        not null, primary key
#  email           :string
#  first_name      :string           not null
#  inn             :string
#  last_name       :string           not null
#  middle_name     :string
#  passport_number :string
#  phone_number    :string
#  ticket_number   :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  students_inn_key              (inn) UNIQUE
#  students_passport_number_key  (passport_number) UNIQUE
#  students_ticket_number_key    (ticket_number) UNIQUE
#

class Student < ApplicationRecord
  include ActsAsLoginable

  validates :first_name, :last_name, presence: true
  validates :inn, :passport_number, :ticket_number, uniqueness: true, allow_blank: true

  def full_name
    "#{first_name} #{last_name}"
  end

  def display_name
    "Student #{id} | #{full_name}"
  end
end
