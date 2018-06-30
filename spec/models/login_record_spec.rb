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

require 'rails_helper'

RSpec.describe LoginRecord, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
