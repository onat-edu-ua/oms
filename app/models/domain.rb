class Domain < ApplicationRecord
  self.table_name='domains'

  has_many :email_redirects, class_name: 'Email::Redirect', foreign_key: :domain_id, dependent: :restrict_with_error

  validates_presence_of :fqdn
  validates_uniqueness_of :fqdn


  def display_name
    "#{fqdn}"
  end

end
