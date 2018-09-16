# == Schema Information
#
# Table name: employees
#
#  id         :bigint(8)        not null, primary key
#  first_name :string           not null
#  last_name  :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Employee, type: :model do
  describe '.create' do
    subject do
      described_class.create(create_params)
    end

    let(:create_params) do
      {
          first_name: 'John',
          last_name: 'Doe',
          login_record_attributes: {
              login: 'john.doe',
              password: 'password123',
              allowed_services: ['', 2, nil, '1', 2]
          }
      }
    end

    include_examples :creates_record do
      let(:expected_record_attrs) do
        create_params.except(:login_record).merge(allowed_services: match_array([1, 2]))
      end
    end
    include_examples :changes_records_count_of, described_class, by: 1

    context 'without first_name' do
      let(:create_params) { super().merge first_name: '' }

      include_examples :changes_records_count_of, described_class, by: 0
      include_examples :does_not_create_record, errors: {
          first_name: "can't be blank"
      }
    end
  end

  describe '#update' do
    subject do
      record.update(update_params)
    end

    let!(:record) { FactoryBot.create(:employee) }
    let(:login_record) { record.login_record }

    context 'change first_name' do
      let(:update_params) { { first_name: 'Jack' } }

      include_examples :updates_record
    end

    context 'change email' do
      let(:update_params) do
        { login_record_attributes: { id: login_record.id, login: 'new.email@example.com' } }
      end

      it 'changes login_record.login' do
        expect { subject }.to change { login_record.reload.login }.to('new.email@example.com')
      end

      include_examples :updates_record do
        let(:expected_record_attrs) { {} }
      end
    end

    context 'change last_name to nil' do
      let(:update_params) { { last_name: nil } }

      include_examples :does_not_update_record, errors: {
          last_name: "can't be blank"
      }
    end
  end

  describe '#destroy' do
    subject do
      record.destroy
    end

    let!(:record) { FactoryBot.create(:employee) }

    include_examples :destroys_record
    include_examples :changes_records_count_of, described_class, by: -1
    include_examples :changes_records_count_of, LoginRecord, by: -1

    context 'when it has wifi sessions' do
      before do
        FactoryBot.create(:wifi_session, username: record.login_record.login)
      end

      include_examples :destroys_record
      include_examples :changes_records_count_of, described_class, by: -1
      include_examples :changes_records_count_of, LoginRecord, by: -1
      include_examples :changes_records_count_of, WifiSession, by: 0
    end
  end
end
