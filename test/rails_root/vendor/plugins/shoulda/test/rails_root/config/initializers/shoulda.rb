# This simulates loading the shoulda plugin, but without relying on
# vendor/plugins

shoulda_path = File.join(File.dirname(__FILE__), *%w(.. .. .. ..))
shoulda_lib_path = File.join(shoulda_path, "lib")

$LOAD_PATH.unshift(shoulda_lib_path)
load File.join(shoulda_path, "init.rb")
