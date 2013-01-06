#
# Cookbook Name:: myroku
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

template "/tmp/grants.sql" do
  source "grants.sql.erb"
end

execute "grant mysql" do
  command "cat /tmp/grants.sql | mysql -uroot -p#{node['mysql']['server_root_password']}"
end
