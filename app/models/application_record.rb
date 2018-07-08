class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.sanitized_ransack_scope_args(args)
    args = args.map(&method(:sanitized_ransack_scope_args)) if args.is_a?(Array)

    if Ransack::Constants::TRUE_VALUES.include? args
      true
    elsif Ransack::Constants::FALSE_VALUES.include? args
      false
    else
      args
    end
  end
end
