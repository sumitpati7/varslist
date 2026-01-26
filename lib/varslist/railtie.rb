require 'rails/railtie'

module Varslist
  class Railtie < Rails::Railtie
    initializer 'varslist.verify_env', after: :load_config_initializers do
      next unless Rails.env.development?
      next unless defined?(Rails::Server)

      Varslist.verify_var_list
    end
  end
end
