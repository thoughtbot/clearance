When /^I add the "([^"]*)" gem$/ do |gem_name|
  append_to_file('Gemfile', %{\ngem "#{gem_name}"\n})
end

When /^I add the "([^"]*)" gem from this project$/ do |gem_name|
  append_to_file('Gemfile', %{\ngem "#{gem_name}", :path => "../../.."\n})
end

When /^I remove the "([^"]*)" gem from this project$/ do |gem_name|
  in_current_dir do
    content = File.read('Gemfile')
    content.gsub!(/^.*gem 'turn'.*\n/, '')
    File.open('Gemfile', 'w') { |file| file.write(content) }
  end
end
