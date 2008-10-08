namespace :shoulda do
  desc "List the names of the test methods in a specification like format"
  task :list do
    $LOAD_PATH.unshift("test")

    require 'test/unit'
    require 'rubygems'
    require 'active_support'

    # bug in test unit.  Set to true to stop from running.
    Test::Unit.run = true

    test_files = Dir.glob(File.join('test', '**', '*_test.rb'))
    test_files.each do |file|
      load file
      klass = File.basename(file, '.rb').classify.constantize

      puts klass.name.gsub('Test', '')

      test_methods = klass.instance_methods.grep(/^test/).map {|s| s.gsub(/^test: /, '')}.sort
      test_methods.each {|m| puts "  " + m }
    end
  end
end
