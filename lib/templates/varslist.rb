# frozen_string_literal: true

Varslist.configure do |config|
  config.enabled = true

  config.skip_files = [
    Rails.root.join('tmp'),
    Rails.root.join('log')
  ]
end
