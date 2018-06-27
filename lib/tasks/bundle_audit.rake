if Rails.env.test? || Rails.env.development?
  require 'bundler/audit/task'
  Bundler::Audit::Task.new
end
