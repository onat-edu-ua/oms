class ApplicationDecorator < Draper::Decorator
  delegate_all

  include Rails.application.routes.url_helpers

  def arbre(&block)
    Arbre::Context.new({}, self, &block).to_s
  end

  def comments_count
    ActiveAdmin::Comment.where(resource_id: self.model.id.to_s, resource_type: self.model.class.to_s).count
  end

end
