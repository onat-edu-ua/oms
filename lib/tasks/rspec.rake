if Rails.env.test? || Rails.env.development?
  require 'rspec/core/rake_task'
  namespace :spec do
    desc 'run rspec without test:prepare'
    RSpec::Core::RakeTask.new(no_prepare: nil)
  end
end
