module ActiveAdminPatch
  module SafeRedirectBack
    def safe_redirect_back(fallback_location = nil)
      redirect_back fallback_location: (fallback_location || admin_root_path)
    end
  end
end

ActiveAdmin::BaseController.include ActiveAdminPatch::SafeRedirectBack
