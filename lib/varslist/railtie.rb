# frozen_string_literal: true

require 'rails/railtie'

# Varslist is a Rails gem that provides environment variable management and validation.
# It ensures that all required environment variables are defined before the Rails server starts.
module Varslist
  # Railtie hooks into Rails initialization process to verify environment variables.
  # It runs during Rails startup and validates that all required variables are configured.
  class Railtie < Rails::Railtie
    initializer 'varslist.verify_env', after: :load_config_initializers do
      next unless defined?(Rails::Server)

      Varslist.config ||= Varslist::Configuration.new
      next unless Varslist.config.enabled

      Varslist.verify_var_list
    end
  end
end
