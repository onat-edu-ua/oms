class LoginableDecorator < ApplicationDecorator
  decorate nil # abstract

  def allowed_service_names
    return @allowed_service_names if defined?(@allowed_service_names)
    @allowed_service_names = Service.where(id: model.login_record.allowed_services).pluck(:name)
  end

  def service_tags
    return nil if allowed_service_names.empty?
    html = allowed_service_names.map do |service|
      arbre { status_tag :yes, label: service }
    end
    h.safe_join(html)
  end

  def login
    model.login_record.login
  end
end
