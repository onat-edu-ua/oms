RSpec.shared_examples :does_not_destroy_record do |errors:|
  let(:expected_record_errors) { errors }

  it 'does not destroy record' do
    expect(subject).to_not be_destroyed
    expected_errors = expected_record_errors.map { |k, v| [k.to_sym, Array.wrap(v)] }.to_h
    expect(record.errors.messages).to match(expected_errors)
  end
end
