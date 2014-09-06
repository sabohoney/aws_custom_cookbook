#
# Cookbook Name:: app
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
# Application Config
template "#{node['cakephp']['install_path']}/bake-composer.sh" do
    cookbook "cakephp"
    mode 0750
    user node['cakephp']['user']
    group node['cakephp']['group']
    variables(
      :include_path => node['cakephp']['install_path'],
      :app_path => node['app']['docroot']
    )
end
directory node['app']['docroot'] do
    action :create
    recursive true
end
%w{lib plugins vendors}.each do |linkto|
    link "#{node['app']['docroot']}/#{linkto}" do
        to "#{node['cakephp']['install_path']}/Vendor/cakephp/cakephp/#{linkto}"
    end
end
bash "Initialize CakePHP" do
    code <<-EOL
        yes #{node['cakephp']['install_path']}/bake-composer.sh
        chown -R nginx:#{node['cakephp']['user']} #{node['app']['docroot']}
        chmod -R o+w #{node['app']['docroot']}/app/tmp/
    EOL
    not_if { ::File.exists?("#{node['app']['docroot']}/app/index.php")}
end

# SSL
cert = ssl_certificate "ssl"
template "#{node['nginx']['dir']}/sites-available/cakephp" do
    source 'cakephp-site.erb'
    owner  'root'
    group  node['root_group']
    mode   '0644'
    notifies :reload, 'service[nginx]'
    variables({
        :SERVER_NAME => node['app']['server_name'],
        :DOCROOT => "#{node['app']['docroot']}/app/webroot",
        :CRT => cert.cert_path,
        :KEY => cert.key_path
    })
end

nginx_site 'cakephp' do
  enable true
end
