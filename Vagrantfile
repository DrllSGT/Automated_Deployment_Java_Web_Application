Vagrant.configure("2") do |config|
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true

### Setup Database Virtual Machine  ####
  config.vm.define "db01" do |db01|
    db01.vm.box = "geerlingguy/centos7"
    db01.vm.hostname = "db-server-01"
    db01.vm.network "private_network", ip: "192.168.2.15"
    db01.vm.provision "shell", path: "mysql.sh"

  end

### Setup Memcached Virtual Machine  ####
  config.vm.define "mc01" do |mc01|
    mc01.vm.box = "geerlingguy/centos7"
    mc01.vm.hostname = "mc-cache-01"
    mc01.vm.network "private_network", ip: "192.168.2.14"
    mc01.vm.provision "shell", path: "memcache.sh"
  end

### Setup RabbitMQ Virtual Machine  ####
  config.vm.define "rmq01" do |rmq01|
    rmq01.vm.box = "geerlingguy/centos7"
  rmq01.vm.hostname = "rmq-broker-01"
    rmq01.vm.network "private_network", ip: "192.168.2.13"
    rmq01.vm.provision "shell", path: "rabbitmq.sh"
  end

### Setup Apache Tomcat Virtual Machine ###
   config.vm.define "app01" do |app01|
    app01.vm.box = "geerlingguy/centos7"
    app01.vm.hostname = "app-server-01"
    app01.vm.network "private_network", ip: "192.168.2.11"
    app01.vm.provision "shell", path: "tomcat.sh"
    app01.vm.provider "virtualbox" do |vb|
     vb.memory = "1024"
   end
   end

### Setup Nginx Virtual Machine ###
  config.vm.define "web01" do |web01|
    web01.vm.box = "ubuntu/xenial64"
    web01.vm.hostname = "web-lb-01"
  web01.vm.network "private_network", ip: "192.168.2.10"
  web01.vm.provision "shell", path: "nginx.sh"
end

end
