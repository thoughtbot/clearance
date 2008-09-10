#!/usr/bin/env ruby
require 'rubygems'
require 'activesupport'
require 'pathname'

project_name = ARGV[0]
fail("Usage:  #{File.basename(__FILE__)} new_project_name")     unless project_name
fail("Project name must only contain [a-z0-9_]")                unless project_name =~ /^[a-z0-9_]+$/

base_directory = Pathname.new(File.join(File.dirname(__FILE__), '..', '..')).realpath
project_directory = base_directory + project_name
fail("Project directory (#{project_directory}) already exists") if project_directory.exist?

template_url = "git@github.com:thoughtbot/rails-template.git"
changeme = "CHANGEME"

def run(cmd)
  puts "Running '#{cmd}'"
  out = `#{cmd}`
  if $? != 0 
    fail "Command #{cmd} failed: #$?\n#{out}" 
  end
  out
end

def search_and_replace(file, search, replace)
  if File.file?(file)
    contents = File.read(file)
    if contents[search]
      puts "Replacing #{search} with #{replace} in #{file}"
      contents.gsub!(search, replace)
      File.open(file, "w") { |f| f << contents }
    end
  end
end

run("mkdir #{project_directory}")
Dir.chdir(project_directory) or fail("Couldn't change to #{project_directory}")
run("git init")
run("git remote add template #{template_url}")
run("git pull template master")

Dir.glob("#{project_directory}/**/*").each do |file|
  search_and_replace(file, changeme, project_name)
end

run("git commit -a -m 'Initial commit'")

puts
puts "Now login to github and add a new project named '#{project_name.humanize.titleize}'"


