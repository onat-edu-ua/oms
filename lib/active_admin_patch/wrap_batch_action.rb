module ActiveAdminPatch
  module WrapBatchAction
    def wrap_batch_action(ids, unknown_error: 'An Error Occurred')
      if ids.size.zero?
        flash[:warning] = 'No records selected.'
        return 0
      end
      errors = []
      success_qty = 0
      scope = apply_authorization_scope(scoped_collection).where(id: ids)
      if scope.count.zero?
        flash[:warning] = 'All selected records are skipped.'
        return 0
      end
      scope.find_each do |record|
        error = nil
        begin
          success = yield(record)
          error = record.errors.any? ? record.errors.full_messages.to_sentence : unknown_error unless success
        rescue StandardError => e
          log_error(e)
          error = "##{record.id} - <#{e.class}>: #{e.message}"
        end
        error.nil? ? success_qty += 1 : errors.push(error)
      end
      flash[:error] = errors.join("\n") unless errors.empty?
      success_qty
    end
  end
end

ActiveAdmin::BaseController.include ActiveAdminPatch::WrapBatchAction
