class TestSeeds
  include Singleton

  class << self
    extend Forwardable
    def_delegator :instance, :load_constants!
  end

  def load_constants!
    load_services
  end

  def load_services
    Service.delete_all
    Service.create! id: Service::CONST::EMAIL, name: 'Email'
    Service.create! id: Service::CONST::EDUROAM, name: 'Eduroam'
  end
end
