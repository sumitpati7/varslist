# frozen_string_literal: true

# spec.required_ruby_version = '>= 3.3.5'

Gem::Specification.new do |s|
  s.name = 'varslist'
  s.version = '0.1.0'
  s.summary = 'Display the list of created Environment variables'
  s.author = 'Sumit Pati'
  s.files = ['lib/varslist.rb', 'bin/varslist', 'Gemfile']
  s.executables = ['varslist']
  s.homepage = 'https://rubygems.org/gems/varslist'
  s.add_dependency "colorize", "~> 1.0", ">= 1.0.4"
  s.metadata['rubygems_mfa_required'] = 'true'
end
