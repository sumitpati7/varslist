# frozen_string_literal: true

return unless defined?(Varslist)

Varslist.configure do |config|
  # If true, enable varslist
  # Default value is true
  # config.enabled = true

  # List of files to be skipped
  # Default value is []
  # config.skip_files = []

  # If true, only show missing envs when the server starts
  # Default value is true
  # config.only_show_missing = true
end
