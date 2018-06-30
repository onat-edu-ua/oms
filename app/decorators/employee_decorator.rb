class EmployeeDecorator < ApplicationDecorator
  decorate Employee

  def allowed_service_names
    return @allowed_service_names if defined?(@allowed_service_names)
    @allowed_service_names = Service.where(id: model.login_record.allowed_services).pluck(:name)
  end

  def service_tags
    allowed_service_names.map do |service|
      arbre { status_tag :yes, label: service }
    end.join.html_safe
  end

  def login
    model.login_record.login
  end

end
