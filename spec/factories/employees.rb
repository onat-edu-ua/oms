# == Schema Information
#
# Table name: employees
#
#  id         :bigint(8)        not null, primary key
#  first_name :string           not null
#  last_name  :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :employee do

    first_name 'Jane'
    last_name 'Doe'

    transient do
      sequence(:login, 100) { |n| "jane.doe.#{n}" }
      password 'test-password'
      allowed_services Service::CONST::IDS
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
