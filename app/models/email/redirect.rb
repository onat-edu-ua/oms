class Email::Redirect < ApplicationRecord


  self.table_name='email_redirects'

  belongs_to :domain, class_name: 'Domain', foreign_key: :domain_id

  validates_presence_of :rewrited_destination, :username, :domain_id
  validates_uniqueness_of :username, scope: :domain_id


  def display_name
    "#{rewrited_destination}"
  end

end
