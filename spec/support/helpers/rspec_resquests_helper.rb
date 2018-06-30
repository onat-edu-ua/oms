module RspecRequestHelper

  def response_json
    json = JSON.parse(response.body)
    json.is_a?(Array) ? json.map(&:deep_symbolize_keys) : json.deep_symbolize_keys
  rescue StandardError => _e
    nil
  end

end
