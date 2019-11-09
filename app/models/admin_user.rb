# == Schema Information
#
# Table name: admin_users
#
#  id                 :bigint(8)        not null, primary key
#  email              :string           default(""), not null
#  encrypted_password :string           default(""), not null
#  role               :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_admin_users_on_email  (email) UNIQUE
#

class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :omniauthable,
  # :recoverable, :rememberable and :trackable
  devise :database_authenticatable, :validatable

  module CONST
    DEFAULT_ROLE = :user

    freeze
  end

  before_validation on: :create do
    self.role ||= CONST::DEFAULT_ROLE
  end

  validates :role, inclusion: { in: proc { |r| r.class.allowed_roles } }

  def root?
    PunditRoles::Configuration.root_role.to_sym == role&.to_sym
  end

  def self.allowed_roles
    roles = PunditRoles::Configuration.roles_config.keys + [PunditRoles::Configuration.root_role]
    roles.map(&:to_s)
  end
end
