RSpec.shared_examples :responds_with_status do |status, head: false, content_type: nil|
  it "responds with #{'head' if head} #{status}" do
    subject
    expect(response.status).to eq(status)
    expect(response.body).to head ? be_blank : be_present
    unless content_type.nil?
      expect(response.headers['Content-Type']).to include(content_type)
    end
  end
end
