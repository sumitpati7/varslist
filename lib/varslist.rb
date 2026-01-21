# frozen_string_literal: true

require 'colorize'

module Varslist
  
  def self.list_env_variables
    env_use_list = []
    watch_list = /\.rb$|\.html\.erb$/
    env_regex = /ENV\[['"]\w+['"]\]|ENV\.fetch/
    filelist = Dir['./**/**/*.*']
    filelist.each do |file|
      if File.basename(file)&.match?(watch_list)
        File.foreach(file).with_index do |line, index|
          next if line.strip.empty? || line.strip.start_with?('#')
          if line&.match?(env_regex)
            env_use_list << { "line" => line.strip, "file_name" => file, "line_number" => index + 1, "var_name" => check_var_name(line)}
          end
        end
      end
    end
    env_use_list
  end

  def self.print_help
    puts "Help for Varslist".colorize(:magenta)
    puts "Use varslist to show all the ENV variables used in all .rb and .erb files"
    puts "--file = to show file list where the ENV variables are used"
    puts "--verify = to verify if all the ENV variable are valid"
  end
  

  def self.check_var_name(line)
    if match = line.scan(/ENV\[['"]([^'"]+)['"]\]|ENV\.fetch\(['"]([^'"]+)['"]/)
      vars=match.flatten.compact.each do |env_var|
        env_var
      end
      vars.join
    else
      nil
    end
  end
  
  def self.print_env(found_envs)
    found_envs.each do |env_line|
      puts "#{env_line["file_name"]}:#{env_line["line_number"]}\t#{env_line["var_name"]}".colorize(:magenta)
      puts "\n\t#{env_line["line"]}\n".colorize(:green)
    end
  end

  
  def self.print_used_var_list(found_envs)
    puts "\n\nThe used ENV variables".colorize(:magenta)
    used_vars=[]
    found_envs.each do |found_env|
      used_vars << found_env["var_name"] unless used_vars.include?(found_env["var_name"])
    end
    used_vars.each do |var|
      puts "\t#{var}".colorize(:green)
    end
  end

  def self.verify_var_list(found_envs)
    valid_env = []
    invalid_env = []
    found_envs.each do |found_env|
      if ENV[found_env["var_name"]].nil?
        invalid_env << found_env["var_name"] unless invalid_env.include?(found_env["var_name"])
      else
        valid_env << found_env["var_name"] unless valid_env.include?(found_env["var_name"])
      end
    end
    if !valid_env.empty?
      puts "\n\nThe valid envs are:".colorize(:magenta)
      valid_env.each do |valid|
        puts "\t#{valid}".colorize(:green)
      end
    end
    if !invalid_env.empty?
      puts "\n\nThe invalid envs are:".colorize(:magenta)
      invalid_env.each do |valid|
        puts "\t#{valid}".colorize(:red)
      end
    end
  end

  # private_class_method :check_environment
end
