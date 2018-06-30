module ActsAsLoginable
  extend ActiveSupport::Concern

  included do
    has_one :login_record, as: :login_entity, dependent: :destroy
    accepts_nested_attributes_for :login_record, update_only: true, allow_destroy: false

    validates :login_record, presence: true, on: :create

    scope :login_record_allowed_services_arr_contains, ->(*values) do
      joins(:login_record).merge(LoginRecord.allowed_services_arr_contains(*values))
    end
  end

  class_methods do
    def ransackable_scopes(_auth = nil)
      [:login_record_allowed_services_arr_contains]
    end
  end
end
