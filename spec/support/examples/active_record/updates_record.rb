RSpec.shared_examples :updates_record do
  let(:expected_record_attrs) { update_params }

  it 'updates record' do
    subject
    expect(subject).to(
      eq(true),
      "expected subject to return, but returns false. Errors:\n#{record.errors.messages}"
    )
    expect(record.errors).to be_empty
  end
end
