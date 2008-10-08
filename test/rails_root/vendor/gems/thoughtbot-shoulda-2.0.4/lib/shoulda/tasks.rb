Dir[File.join(File.dirname(__FILE__), 'tasks', '*.rake')].each do |f|
  load f
end
