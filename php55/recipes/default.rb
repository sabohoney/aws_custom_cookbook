#
# Cookbook Name:: yum-remi-php55
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#case node['platform']
#when 'redhat', 'centos'
    include_recipe "php55::remi"
    include_recipe "php55::remi-php55"
#eend

include_recipe "php55::php55"

execute "PHP Session Directory Change Owner" do
    command "chown -R root:#{node['cakephp']['user']} /var/lib/php/session/"
end