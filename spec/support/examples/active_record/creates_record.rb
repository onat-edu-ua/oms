RSpec.shared_examples :creates_record do
  let(:expected_record_attrs) { create_params }

  it 'creates record' do
    subject
    expect(subject).to(
      be_persisted,
      "expected subject to be persisted, but it's not. Errors:\n#{subject.errors.messages}"
    )
    expect(subject.errors).to be_empty
    expect(subject.class.where(id: subject.id).count).to eq(1)
  end
end
