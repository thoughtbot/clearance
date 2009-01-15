# Mostly pinched from http://github.com/ryanb/nifty-generators/tree/master

Rails::Generator::Commands::Base.class_eval do
  def file_contains?(relative_destination, line)
    File.read(destination_path(relative_destination)).include?(line)
  end
end

Rails::Generator::Commands::Create.class_eval do

  def route_resources(resource_list)
    sentinel = 'ActionController::Routing::Routes.draw do |map|'
    
    logger.route "map.resources #{resource_list}"
    unless options[:pretend] || file_contains?('config/routes.rb', resource_list)
      gsub_file 'config/routes.rb', /(#{Regexp.escape(sentinel)})/mi do |match|
        "#{match}\n  map.resources #{resource_list}"
      end
    end
  end

  def route_resource(resource_list)
    sentinel = 'ActionController::Routing::Routes.draw do |map|'
    
    logger.route "map.resource #{resource_list}"
    unless options[:pretend] || file_contains?('config/routes.rb', resource_list)
      gsub_file 'config/routes.rb', /(#{Regexp.escape(sentinel)})/mi do |match|
        "#{match}\n  map.resource #{resource_list}"
      end
    end
  end
  
  def route_name(name, path, route_options = {})
    sentinel = 'ActionController::Routing::Routes.draw do |map|'
    
    logger.route "map.#{name} '#{path}', :controller => '#{route_options[:controller]}', :action => '#{route_options[:action]}'"
    unless options[:pretend] 
      gsub_file_once 'config/routes.rb', /(#{Regexp.escape(sentinel)})/mi do |match|
        "#{match}\n  map.#{name} '#{path}', :controller => '#{route_options[:controller]}', :action => '#{route_options[:action]}'"
      end
    end
  end
  
  def insert_into(file, line)
    logger.insert "#{line} into #{file}"
    unless options[:pretend] || file_contains?(file, line)
      gsub_file file, /^(class|module) .+$/ do |match|
        "#{match}\n  #{line}"
      end
    end
  end
end

Rails::Generator::Commands::Destroy.class_eval do
  def route_resource(resource_list)
    look_for = "  map.resource #{resource_list}\n".gsub(/[\[\]]/, '\\\\\0')
    logger.route "map.resource #{resource_list} #{look_for}"
    unless options[:pretend]
      gsub_file 'config/routes.rb', /(#{look_for})/mi, ''
    end
  end
  
  def route_resources(resource_list)
    look_for = "  map.resources #{resource_list}\n".gsub(/[\[\]]/, '\\\\\0')
    logger.route "map.resources #{resource_list} #{look_for}"
    unless options[:pretend]
      gsub_file 'config/routes.rb', /(#{look_for})/mi, ''
    end
  end  
  
  def route_name(name, path, route_options = {})
    look_for =   "\n  map.#{name} '#{path}', :controller => '#{route_options[:controller]}', :action => '#{route_options[:action]}'"
    logger.route "map.#{name} '#{path}',     :controller => '#{route_options[:controller]}', :action => '#{route_options[:action]}'"
    unless options[:pretend]
      gsub_file    'config/routes.rb', /(#{look_for})/mi, ''
    end
  end
  
  def insert_into(file, line)
    logger.remove "#{line} from #{file}"
    unless options[:pretend]
      gsub_file file, "\n  #{line}", ''
    end
  end
end

Rails::Generator::Commands::List.class_eval do
  def route_resource(resources_list)
    logger.route "map.resource #{resource_list}"
  end
  
  def route_resources(resources_list)
    logger.route "map.resource #{resource_list}"
  end  
  
  def route_name(name, path, options = {})
    logger.route "map.#{name} '#{path}', :controller => '{options[:controller]}', :action => '#{options[:action]}'"
  end
  
  def insert_into(file, line)
    logger.insert "#{line} into #{file}"
  end
end
