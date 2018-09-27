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
  has_many :wifi_sessions, inverse_of: :login_record, foreign_key: :username, primary_key: :login, dependent: false

  before_validation do
    self.allowed_services = fixed_allowed_services if allowed_services_changed?
  end

  validates :login, :password, presence: true
  validates :login_entity, presence: true
  validate do
    if services.count != allowed_services.size
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

  scope :allowed_services_empty, ->(flag = true) do
    flag = sanitized_ransack_scope_args(flag)
    flag ? where(allowed_services: []) : where.not(allowed_services: [])
  end

  def services
    Service.where(id: allowed_services)
  end

  def self.ransackable_scopes(_auth = nil)
    [:allowed_services_arr_contains, :allowed_services_empty]
  end

  private

  def fixed_allowed_services
    (allowed_services ? allowed_services.reject(&:nil?) : []).uniq
  end
end
