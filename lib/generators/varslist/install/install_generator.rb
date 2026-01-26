# frozen_string_literal: true

require 'rails/generators'

module Varslist
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../../../templates', __dir__)

      def create_initializer
        template 'varslist.rb', 'config/initializers/varslist.rb'
      end
    end
  end
end
