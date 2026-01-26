# frozen_string_literal: true

# spec.required_ruby_version = '>= 3.3.5'

Gem::Specification.new do |s|
  s.name = 'varslist'
  s.version = '0.2.1'
  s.summary = 'Display the list of created Environment variables'
  s.author = 'Sumit Pati'
  s.files = ['lib/varslist.rb', 'bin/varslist', 'Gemfile']
  s.executables = ['varslist']
  s.add_dependency "colorize", "~> 1.0", ">= 1.0.4"
  s.metadata['rubygems_mfa_required'] = 'true'
  s.description = "Varslist is a ruby gem that helps to identify the env variables that are being used in your project"
  s.homepage = "https://github.com/sumitpati7/varslist"
end
