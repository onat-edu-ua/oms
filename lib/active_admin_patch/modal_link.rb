# ActiveAdminModalLink
module ActiveAdminPatch
  module ModalLink
    def modal_link(title, options = {})
      form_name = options.fetch(:form_name) { title.tr(' ', '_').downcase }
      url = options.fetch(:url) do
        url_params = { action: form_name, id: params[:id] }.reject { |_, v| v.nil? }
        url_for(url_params)
      end
      http_method = options.fetch(:method, :put)

      data = {
          url: url,
          method: http_method,
          form_name: form_name,
          confirm: options[:confirm] || title
      }
      data[:confirm] = options[:confirm] || title
      data[:inputs] = options[:inputs] if options[:inputs]
      data[:extra] = options[:extra] if options[:extra]
      data[:default_values] = options[:default_values] if options[:default_values]
      data.merge! options[:link_data] if options[:link_data]

      classes = ['modal-link', options[:class]].compact.join(' ')
      link_html = { class: classes, data: data }
      link_html.merge! options[:link_html] if options[:link_html]

      link_to(title, '#', link_html)
    end
  end

  module ModalLinkHelper
    extend ActiveSupport::Concern

    included do
      helper ActiveAdminPatch::ModalLink
    end
  end
end

ActiveAdmin::BaseController.include ActiveAdminPatch::ModalLinkHelper
