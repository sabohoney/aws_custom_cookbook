#
# Cookbook Name:: cakephp
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package "php-mcrypt"
package "php-pdo"

php_pear_channel "pear.cakephp.org" do
  action :discover
end

# Composer Initialize
directory node['cakephp']['install_path'] do
    user node['cakephp']['user']
    group node['cakephp']['group']
    recursive true
    action :create
end

template "#{node['cakephp']['install_path']}/composer.json" do
    user node['cakephp']['user']
    group node['cakephp']['group']
end

#install project vendors
composer_project node['cakephp']['install_path'] do
    dev false
    quiet true
    prefer_dist false
    action :install
end