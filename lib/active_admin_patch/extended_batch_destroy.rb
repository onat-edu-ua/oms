module ActiveAdminPatch
  module ExtendedBatchDestroy
    def extended_batch_destroy!(confirm: nil, unknown_error: nil, success: nil)
      confirm ||= 'Are you sure that you want to destroy those record?'
      unknown_error ||= 'Failed to destroy record'
      success ||= ->(success_qty, ids_size) { "#{success_qty}/#{ids_size} record were successfully destroyed." }
      batch_action :destroy, confirm: confirm, if: proc { authorized?(:batch_destroy, resource_class) } do |ids|
        authorize!(:batch_destroy, resource_class)
        success_qty = wrap_batch_action(ids, unknown_error: unknown_error) do |record|
          record.destroy
          record.destroyed?
        end
        flash[:notice] = success.call(success_qty, ids.size) if success_qty.positive?
        safe_redirect_back
      end
    end
  end
end

ActiveAdmin::ResourceDSL.include ActiveAdminPatch::ExtendedBatchDestroy
