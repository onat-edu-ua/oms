class Domain < ApplicationRecord
  self.table_name = 'domains'

  has_many :email_redirects, class_name: 'Email::Redirect', foreign_key: :domain_id, inverse_of: :domain, dependent: :restrict_with_error

  validates :fqdn, presence: true
  validates :fqdn, uniqueness: true

  def display_name
    fqdn.to_s
  end
end
