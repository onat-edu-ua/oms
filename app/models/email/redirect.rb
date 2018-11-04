class Email::Redirect < ApplicationRecord
  self.table_name = 'email_redirects'

  belongs_to :domain, class_name: 'Domain', foreign_key: :domain_id, inverse_of: :email_redirects

  validates :rewrited_destination, :username, :domain_id, presence: true
  validates :username, uniqueness: { scope: :domain_id }

  def display_name
    rewrited_destination.to_s
  end
end
