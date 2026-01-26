# frozen_string_literal: true

module Varslist
  # Default configuration
  class Configuration
    attr_accessor :skip_files, :enabled, :only_show_missing

    def initialize
      @enabled = true
      @skip_files = []
      @only_show_missing = true
    end
  end
end
