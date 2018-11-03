class EduroamAuthorize
  class Error < StandardError
  end

  class NotFoundError < Error
    def initialize(login)
      super("Login not found: #{login.inspect}")
    end
  end

  def self.authorize!(login)
    new(login).authorize!
  end

  def initialize(login)
    @login = login
  end

  def authorize!
    record = allowed_scope.find_by(login: @login)
    raise NotFoundError, @login if record.nil?
    authorization_data_for(record)
  end

  private

  def authorization_data_for(record)
    {
#        'User-Name': record.login,
        'control:Cleartext-Password': record.password,
        'Acct-Interim-Interval': 60
    }
  end

  def allowed_scope
    LoginRecord.allowed_services_arr_contains(Service::CONST::EDUROAM)
  end
end
