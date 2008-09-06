namespace :shoulda do
  # From http://blog.internautdesign.com/2007/11/2/a-yaml_to_shoulda-rake-task
  # David.Lowenfels@gmail.com
  desc "Converts a YAML file (FILE=./path/to/yaml) into a Shoulda skeleton" 
  task :from_yaml do
    require 'yaml'
    
    def yaml_to_context(hash, indent = 0)
      indent1 = '  ' * indent
      indent2 = '  ' * (indent + 1)
      hash.each_pair do |context, shoulds|
        puts indent1 + "context \"#{context}\" do" 
        puts    
        shoulds.each do |should|
          yaml_to_context( should, indent + 1 ) and next if should.is_a?( Hash )
          puts indent2 + "should_eventually \"" + should.gsub(/^should +/,'') + "\" do" 
          puts indent2 + "end" 
          puts
        end
        puts indent1 + "end" 
      end
    end 
    
    puts("Please pass in a FILE argument.") and exit unless ENV['FILE']
      
    yaml_to_context( YAML.load_file( ENV['FILE'] ) )
  end
end