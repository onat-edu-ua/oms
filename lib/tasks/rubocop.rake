if Rails.env.test? || Rails.env.development?
  require 'rubocop/rake_task'
  desc 'Checks ruby code style with RuboCop'
  RuboCop::RakeTask.new
end
