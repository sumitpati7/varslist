require 'rails/railtie'

module Varslist
  class Railtie < Rails::Railtie
    initializer "varslist.verify_env", before: :load_environment_config do
      next unless Rails.env.development?


      Varslist.verify!
    end
  end
end
