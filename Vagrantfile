Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial32"

  config.vm.provision "shell", inline: <<-SHELL
    apt-get update
    apt-get upgrade -y
    apt-get autoremove
    apt-get install -y ruby ruby-dev zlib1g-dev libsqlite3-dev
    apt-get -y autoremove
    cd /vagrant
    ./bin/setup
  SHELL
end
