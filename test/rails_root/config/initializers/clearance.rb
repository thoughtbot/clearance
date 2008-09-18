# This simulates loading the clearance gem, but without relying on
# vendor/gems

clearance_path = File.join(File.dirname(__FILE__), *%w(.. .. .. ..))
clearance_lib_path = File.join(clearance_path, "lib")

$LOAD_PATH.unshift(clearance_lib_path)
load File.join(clearance_path, 'rails', 'init.rb')
