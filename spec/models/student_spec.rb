# == Schema Information
#
# Table name: students
#
#  id              :bigint(8)        not null, primary key
#  email           :string
#  first_name      :string           not null
#  inn             :string
#  last_name       :string           not null
#  middle_name     :string
#  passport_number :string
#  phone_number    :string
#  ticket_number   :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  students_inn_key              (inn) UNIQUE
#  students_passport_number_key  (passport_number) UNIQUE
#  students_ticket_number_key    (ticket_number) UNIQUE
#

require 'rails_helper'

RSpec.describe Student, type: :model do
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

    it 'creates login record with correct attributes' do
      expect(subject.login_record).to be_persisted
      expect(subject.login_record).to have_attributes(
        login: 'john.doe',
        password: 'password123',
        allowed_services: match_array([1, 2])
      )
    end

    include_examples :creates_record do
      let(:expected_record_attrs) { create_params.except(:login_record_attributes) }
    end
    include_examples :changes_records_count_of, described_class, by: 1
    include_examples :changes_records_count_of, LoginRecord, by: 1

    context 'with inn, ticket_number and passport_number as empty strings' do
      let(:create_params) do
        super().merge inn: '', passport_number: '', ticket_number: ''
      end

      it 'creates employee with correct fields' do
        expect { subject }.to change {
          described_class.where(inn: nil, passport_number: nil, ticket_number: nil).count
        }.by(1)
      end

      include_examples :creates_record do
        let(:expected_record_attrs) do
          create_params.except(:login_record).merge(
            inn: nil,
            passport_number: '',
            ticket_number: '',
            allowed_services: match_array([1, 2])
          )
        end
      end
      include_examples :changes_records_count_of, described_class, by: 1
      include_examples :changes_records_count_of, LoginRecord, by: 1
    end

    context 'with optional attributes' do
      let(:create_params) do
        super().merge middle_name: 'Jamesovich',
                      email: 'john.doe@example.com',
                      inn: '1234567890',
                      passport_number: 'AZ123456',
                      phone_number: '+987654321',
                      ticket_number: '6781245774357'
      end

      it 'creates login record with correct attributes' do
        expect(subject.login_record).to be_persisted
        expect(subject.login_record).to have_attributes(
          login: 'john.doe',
          password: 'password123',
          allowed_services: match_array([1, 2])
        )
      end

      include_examples :creates_record do
        let(:expected_record_attrs) do
          create_params.except(:login_record).merge(allowed_services: match_array([1, 2]))
        end
      end
      include_examples :changes_records_count_of, described_class, by: 1
      include_examples :changes_records_count_of, LoginRecord, by: 1
    end

    context 'without first_name' do
      let(:create_params) { super().merge first_name: '' }

      include_examples :changes_records_count_of, described_class, by: 0
      include_examples :does_not_create_record, errors: {
          first_name: "can't be blank"
      }
    end

    context 'without services' do
      let(:create_params) { super().deep_merge login_record_attributes: { allowed_services: [] } }

      it 'creates login record with correct attributes' do
        expect(subject.login_record).to be_persisted
        expect(subject.login_record).to have_attributes(
          login: 'john.doe',
          password: 'password123',
          allowed_services: []
        )
      end

      include_examples :creates_record do
        let(:expected_record_attrs) { create_params.except(:login_record_attributes) }
      end
      include_examples :changes_records_count_of, described_class, by: 1
      include_examples :changes_records_count_of, LoginRecord, by: 1
    end
  end

  describe '#update' do
    subject do
      record.update(update_params)
    end

    let!(:record) { FactoryBot.create(:student) }
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

    let!(:record) { FactoryBot.create(:student) }

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
