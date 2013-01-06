Vagrant::Config.run do |config|
  config.vm.host_name = "myroku-server"
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  config.vm.network :hostonly, "192.168.110.111"
  config.vm.customize ["modifyvm", :id, "--memory", 512]
  config.vm.customize ["modifyvm", :id, "--cpus", 4]
  config.vm.provision CapProvision, :task => "vagrant deploy:setup"
  config.vm.provision CapProvision, :task => "vagrant deploy"
end

class CapProvision < Vagrant::Provisioners::Base
  class Config < Vagrant::Config::Base
    attr_accessor :task
  end

  def self.config_class
    Config
  end

  def provision!
    system("cap #{config.task}")
  end

end
