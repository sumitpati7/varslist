# frozen_string_literal: true

require 'colorize'
require_relative 'varslist/errors'
require_relative 'varslist/configuration'
require_relative 'varslist/railtie' if defined?(Rails::Railtie)

module Varslist
  class << self
    attr_accessor :config

    def env_vars
      @env_vars ||= list_env_variables
    end
    
    def list_env_variables
      # Ensure config is initialized
      @config ||= Configuration.new
      
      env_use_list = []
      watch_list = /\.rb$|\.html\.erb$/
      env_regex = /ENV\[['"]\w+['"]\]|ENV\.fetch/
      filelist = Dir['./**/**/*.*']
      filelist.each do |file|
        next if @config.skip_files&.any? { |skip_item| matches_skip_item?(file, skip_item) }

        if File.basename(file)&.match?(watch_list)
          File.foreach(file).with_index do |line, index|
            next if line.strip.empty? || line.strip.start_with?('#')
            if line&.match?(env_regex)
              check_var_name(line).each do |var_info|
                env_use_list << { 
                  "line" => line.strip, 
                  "file_name" => file, 
                  "line_number" => index + 1, 
                  "var_name" => var_info[:name],
                  "has_default" => var_info[:has_default]
                }
              end
            end
          end
        end
      end
      env_use_list
    end

    def print_help
      puts "Help for Varslist".colorize(:magenta)
      puts "Use varslist to show all the ENV variables used in all .rb and .erb files"
      puts "--file = to show file list where the ENV variables are used"
      puts "--verify = to verify if all the ENV variable are valid"
    end
    

    def check_var_name(line)
      results = []
      
      line.scan(/ENV\[['"]([^'"]+)['"]\]/) do |match|
        results << { name: match[0], has_default: false }
      end
      
      line.scan(/ENV\.fetch\(\s*['"]([^'"]+)['"]\s*(?:,\s*([^)]*))?\s*\)\s*(\{)?/) do |name, default_arg, block_start|
        has_default = !default_arg.nil? || !block_start.nil?
        results << { name: name, has_default: has_default }
      end
      
      results
    end
    
    def print_env(found_envs)
      found_envs.each do |env_line|
        puts "#{env_line["file_name"]}:#{env_line["line_number"]}\t#{env_line["var_name"]}".colorize(:magenta)
        puts "\n\t#{env_line["line"]}\n".colorize(:green)
      end
    end

    
    def print_used_var_list(found_envs)
      puts "\nThe used ENV variables".colorize(:magenta)
      used_vars=[]
      found_envs.each do |found_env|
        used_vars << found_env["var_name"] unless used_vars.include?(found_env["var_name"])
      end
      used_vars.each do |var|
        puts "\t#{var}".colorize(:green)
      end
    end

    def verify_var_list
      valid_env, invalid_env = fetch_used_and_unused_vars
      if !valid_env.empty?
        puts "\nThe valid envs are:".colorize(:magenta)
        puts "#{valid_env.join(", ")}".colorize(:green)
      end
      if !invalid_env.empty?
        puts "\nThe missing envs are:".colorize(:magenta)
        puts "#{invalid_env.join(", ")}".colorize(:red)
      end
    end

    def verify!
      invalid_env = fetch_used_and_unused_vars[1]
      if invalid_env.empty?
        puts "\n\nThe envs are valid".colorize(:green)
      else
        message = "The envs are invalid"
        puts "\n\nThe envs are invalid".colorize(:red)
        raise Varslist::MissingEnvError, message
      end
    end

    def fetch_used_and_unused_vars
      valid_env = []
      invalid_env = []
      
      # Track status for each variable
      # A variable is invalid only if it is missing AND required at least once (no default)
      vars_status = {}
      
      env_vars.each do |found_env|
        name = found_env["var_name"]
        vars_status[name] ||= { required: false, present: !ENV[name].nil? }
        vars_status[name][:required] = true unless found_env["has_default"]
      end
      
      vars_status.each do |name, status|
        if status[:present] || !status[:required]
          valid_env << name
        else
          invalid_env << name
        end
      end
      
      [valid_env, invalid_env]
    end
    private


    def matches_skip_item?(file, skip_item)
      pattern = skip_item.to_s
      # Check for glob matches
      return true if File.fnmatch?(pattern, file, File::FNM_PATHNAME | File::FNM_DOTMATCH)
      return true if File.fnmatch?(pattern, file.delete_prefix('./'), File::FNM_PATHNAME | File::FNM_DOTMATCH)

      # Check for absolute path matches or directory prefix matches
      abs_file = File.expand_path(file)
      abs_pattern = File.expand_path(pattern)

      return true if abs_file == abs_pattern
      return true if abs_file.start_with?(File.join(abs_pattern, ''))

      false
    end
  end

  def self.configure
    self.config ||= Configuration.new
    yield(config) if block_given?
  end
end
