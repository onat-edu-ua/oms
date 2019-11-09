module ActiveAdminPatch
  module WrapAction
    def wrap_action(fallback_location: admin_root_path)
      begin
        yield
      rescue StandardError => e
        log_error(e)
        flash[:error] = e.message
      end
      redirect_back(fallback_location: fallback_location)
    end
  end
end

ActiveAdmin::BaseController.include ActiveAdminPatch::WrapAction
