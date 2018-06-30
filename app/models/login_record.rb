# == Schema Information
#
# Table name: login_records
#
#  id                :bigint(8)        not null, primary key
#  allowed_services  :integer          default([]), not null, is an Array
#  login             :string           not null
#  login_entity_type :string           not null
#  password          :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  login_entity_id   :integer          not null
#
# Indexes
#
#  index_login_records_on_login                                  (login) UNIQUE
#  index_login_records_on_login_entity_id_and_login_entity_type  (login_entity_id,login_entity_type) UNIQUE
#

class LoginRecord < ApplicationRecord
  module CONST
    LOGIN_REGEXP = /[0-9A-Za-z\-_.]+/

    freeze
  end

  belongs_to :login_entity, polymorphic: true

  before_validation do
    if allowed_services_changed?
      self.allowed_services = (allowed_services ? allowed_services.reject(&:nil?) : []).uniq
    end
  end

  validates :login, :password, presence: true
  validates :login_entity, presence: true
  validate do
    if (allowed_services - Service::CONST::IDS).any?
      errors.add(:allowed_services, :invalid)
    end
  end

  scope :allowed_services_arr_contains, ->(*values) do
    values = values.reject(&:blank?)
    type = ActiveRecord::Type::Integer.new(limit: 2)
    array_type = ActiveRecord::ConnectionAdapters::PostgreSQL::OID::Array.new(type)
    data = array_type.serialize(values)
    encoded_data = data.encoder.encode(data.values)
    where("#{table_name}.allowed_services @> ?", encoded_data)
  end

  def self.ransackable_scopes(_auth = nil)
    [:allowed_services_arr_contains]
  end
end
