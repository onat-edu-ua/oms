class WifiSessionDecorator < ApplicationDecorator
  decorate WifiSession

  def login_link
    h.auto_link(model.login_record&.login_entity, model.username)
  end
end
