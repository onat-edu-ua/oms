RSpec.shared_examples :destroys_record do
  it 'destroys record' do
    subject
    expect(record).to(
      be_destroyed,
      "expected subject to be destroyed, but it's not. Errors:\n#{record.errors.messages}"
    )
    expect(record.errors).to be_empty
    expect(record.class.where(id: record.id).count).to eq(0)
  end
end
