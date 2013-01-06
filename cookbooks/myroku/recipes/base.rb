#
# Cookbook Name:: base
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
case node['platform']
when "ubuntu","debian"
  include_recipe "apt"
  package "expect"
  script "dpkg-reconfigure dash" do
    interpreter "bash"
    user "root"
    code <<-EOF
echo "dash    dash/sh boolean false" | debconf-set-selections ; dpkg-reconfigure --frontend=noninteractive dash
    EOF
  end
end
include_recipe "build-essential"

package "vim" do
  action :install
end
package "strace" do
  action :install
end
package "dstat" do
  action :install
end

node.set['redisio']['default_settings']['databases'] = 1002
node.set['authorization']['sudo']['groups'] = ['sudo']
node.set['authorization']['sudo']['passwordless'] = true

include_recipe 'myroku::user'

include_recipe 'daemontools'
service "daemontools" do
  case node[:platform_family]
  when "debian"
    service_name "svscan"
    provider Chef::Provider::Service::Upstart
  end
  action [ :enable, :start ]
end
