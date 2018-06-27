# == Schema Information
#
# Table name: login_records
#
#  id                :bigint(8)        not null, primary key
#  login             :string           not null
#  login_entity_type :string           not null
#  password_digest   :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  login_entity_id   :integer          not null
#
# Indexes
#
#  index_login_records_on_login                                  (login) UNIQUE
#  index_login_records_on_login_entity_id_and_login_entity_type  (login_entity_id,login_entity_type) UNIQUE
#

FactoryBot.define do
  factory :login_record do
  end
end
