module ParamsParser
  class Base
    class_attribute :root_key, instance_writer: false

    attr_reader :params

    def initialize(params)
      @params = params
    end

    # override this method to define permitted keys
    def permitted_params
      []
    end

    def permit!
      safe_params.to_h
    end

    def safe_params
      if root_key.nil?
        params.slice(*permitted_params_names).permit(*permitted_params)
      else
        params.require(root_key).permit(*permitted_params)
      end
    end

    private

    def permitted_params_names
      permitted_params.map do |param|
        param.is_a?(Hash) ? param.keys : param
      end.flatten
    end
  end
end
