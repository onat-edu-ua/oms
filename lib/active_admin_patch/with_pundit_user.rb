module ActiveAdminPatch
  module WithPunditUser
    extend ActiveSupport::Concern

    def pundit_user
      current_admin_user
    end
  end
end

ActiveAdmin::BaseController.include ActiveAdminPatch::WithPunditUser
