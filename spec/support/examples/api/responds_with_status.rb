RSpec.shared_examples :responds_with_status do |status, head: false|
  it "responds with #{'head' if head} #{status}" do
    subject
    expect(response.status).to eq(status)
    expect(response.body).to head ? be_blank : be_present
  end
end
