RSpec.shared_examples :does_not_create_record do |errors:|
  let(:expected_record_errors) { errors }

  it 'does not create record' do
    subject
    expect(subject).to be_new_record
    expected_errors = expected_record_errors.map { |k, v| [k.to_sym, Array.wrap(v)] }.to_h
    expect(subject.errors.messages).to match(expected_errors)
  end
end
