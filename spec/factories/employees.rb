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

FactoryBot.define do
  factory :employee do
    first_name { 'Jane' }
    last_name { 'Doe' }

    transient do
      sequence(:login, 100) { |n| "jane.doe.#{n}" }
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
