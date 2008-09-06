# This simulates loading the shoulda plugin, but without relying on
# vendor/plugins

clearance_path = File.join(File.dirname(__FILE__), *%w(.. .. .. ..))
clearance_lib_path = File.join(clearance_path, "lib")

$LOAD_PATH.unshift(clearance_lib_path)
load File.join(clearance_path, 'rails', 'init.rb')
