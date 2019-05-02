class ApplicationForm
  include ActiveModel::Model
  include ExceptionHandler

  class FormInvalid < StandardError
    attr_reader :form

    def initialize(form)
      @form = form
      super("Validation failed: #{form.errors.full_messages.to_sentence}.")
    end
  end

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
    params.to_h.each do |key, value|
      public_send("#{key}=", value)
    end
  end

  def save(ctx = nil)
    ctx ||= {}
    validate = ctx.fetch(:validate, true)
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

  def save!(ctx = nil)
    save(ctx) || raise(FormInvalid, self)
  end

  # call throw(:error) for fail save process (#save method will return false)
  def _save
    raise NotImplementedError, 'override #_save in a subclass'
  end
end
