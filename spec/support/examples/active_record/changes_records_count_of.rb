RSpec.shared_examples :changes_records_count_of do |klass, by:|
  it "changes records count of #{klass} by #{by}" do
    expect { subject }.to change { klass.count }.by(by)
  end
end
