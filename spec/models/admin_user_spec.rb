# == Schema Information
#
# Table name: admin_users
#
#  id                 :bigint(8)        not null, primary key
#  email              :string           default(""), not null
#  encrypted_password :string           default(""), not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_admin_users_on_email  (email) UNIQUE
#

require 'rails_helper'

RSpec.describe AdminUser, type: :model do
  describe '.create' do
    subject do
      described_class.create(create_params)
    end

    let(:create_params) do
      { email: 'john.doe@example.com', password: '123456', password_confirmation: '123456' }
    end

    include_examples :creates_record do
      let(:expected_record_attrs) { create_params.slice(:email) }
    end
    include_examples :changes_records_count_of, described_class, by: 1

    context 'without email' do
      let(:create_params) { super().merge email: '' }

      include_examples :changes_records_count_of, described_class, by: 0
      include_examples :does_not_create_record, errors: {
          email: "can't be blank"
      }
    end
  end

  describe '#update' do
    subject do
      record.update(update_params)
    end

    let!(:record) { FactoryBot.create(:admin_user) }

    context 'change email' do
      let(:update_params) { { email: 'new.mail@example.com' } }

      include_examples :updates_record
    end

    context 'change password to 3 char length' do
      let(:update_params) { { password: 'foo', password_confirmation: 'foo' } }

      include_examples :does_not_update_record, errors: {
          password: 'is too short (minimum is 6 characters)'
      }
    end
  end

  describe '#destroy' do
    subject do
      record.destroy
    end

    let!(:record) { FactoryBot.create(:admin_user) }

    include_examples :destroys_record
    include_examples :changes_records_count_of, described_class, by: -1
  end
end
