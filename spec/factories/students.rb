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

FactoryBot.define do
  factory :student do
    first_name { 'Jane' }
    last_name { 'Doe' }

    transient do
      sequence(:login, 100) { |n| "jack.doe.#{n}" }
      password { 'test-password' }
      allowed_services { Service.pluck(:id) }
    end

    after(:build) do |record, ev|
      record.assign_attributes(login_record_attributes: {
          login: ev.login,
          password: ev.password,
          allowed_services: ev.allowed_services
      })
    end
  end
end
