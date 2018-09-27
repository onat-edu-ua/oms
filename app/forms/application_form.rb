class ApplicationForm
  include ActiveModel::Model
  include ExceptionHandler

  class << self
    def attributes(*names)
      options = names.extract_options!
      names.each { |name| attribute(name, options) }
    end

    def attribute(name, _options = {})
      attr_accessor name
    end
  end

  def initialize(params = {})
    assign_attributes(params) unless params.nil?
  end

  def assign_attributes(params)
    params.each do |key, value|
      public_send("#{key}=", value)
    end
  end

  def save(validate: true)
    if !validate || valid?
      success = false
      catch(:error) do
        _save
        success = true
      end
      success
    else
      false
    end
  end

  # call throw(:error) for fail save process (#save method will return false)
  def _save
    raise NotImplementedError, 'override #_save in a subclass'
  end
end
