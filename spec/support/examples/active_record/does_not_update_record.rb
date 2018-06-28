RSpec.shared_examples :does_not_update_record do |errors: nil|
  let(:expected_record_errors) do
    errors || raise(StandardError, 'does_not_update_record errors must be filled')
  end

  it 'does not update record' do
    expect(subject).to eq(false)
    expected_errors = expected_record_errors.map { |k, v| [k.to_sym, Array.wrap(v)] }.to_h
    expect(record.errors.messages).to match(expected_errors)
  end
end
