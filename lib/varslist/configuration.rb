# frozen_string_literal: true

module Varslist
  # Default configuration
  class Configuration
    attr_accessor :skip_files, :enabled

    def initialize
      @enabled = true
      @skip_files = [
        'tmp/**',
        'log/**'
      ]
    end
  end
end
