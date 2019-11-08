RSpec.describe Api::Eduroam::AuthorizeController do
  describe 'GET /api/eduroam/{login}/authorize' do
    subject do
      get "/api/eduroam/#{login}/authorize"
    end

    let(:login) { record.login }

    context 'when employee' do
      let!(:employee) { FactoryBot.create(:employee, employee_attrs) }
      let(:employee_attrs) { {} }
      let(:record) { employee.login_record }

      include_examples :responds_with_status, 200, content_type: 'application/json'

      it 'responds with correct data for radius' do
        subject
        expect(response_json).to match(
          'control:Cleartext-Password': record.password,
          'Acct-Interim-Interval': 60
        )
      end

      context 'without eduroam service' do
        let(:employee_attrs) { super().merge allowed_services: [Service::CONST::EMAIL] }

        include_examples :responds_with_status, 404, content_type: 'application/json'
      end

      context 'when error appears' do
        before do
          expect(EduroamAuthorize).to receive(:authorize!).and_raise(StandardError, 'test error')
        end

        include_examples :responds_with_status, 500, content_type: 'application/json'
      end
    end

    context 'when student' do
      let!(:student) { FactoryBot.create(:student, student_attrs) }
      let(:student_attrs) { {} }
      let(:record) { student.login_record }

      include_examples :responds_with_status, 200, content_type: 'application/json'

      it 'responds with correct data for radius' do
        subject
        expect(response_json).to match(
          'control:Cleartext-Password': record.password,
          'Acct-Interim-Interval': 60
        )
      end

      context 'without eduroam service' do
        let(:student_attrs) { super().merge allowed_services: [Service::CONST::EMAIL] }

        include_examples :responds_with_status, 404, content_type: 'application/json'
      end

      context 'when error appears' do
        before do
          expect(EduroamAuthorize).to receive(:authorize!).and_raise(StandardError, 'test error')
        end

        include_examples :responds_with_status, 500, content_type: 'application/json'
      end
    end
  end
end
