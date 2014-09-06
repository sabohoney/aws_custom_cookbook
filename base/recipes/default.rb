#
# Cookbook Name:: base
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package "git"
package "curl"
package "bash-completion"
package "vim-enhanced"
package "gd"
package "ImageMagick"

cookbook_file "/tmp/bashrc.txt" do
    source node['platform'] == 'amazon' ? 'bashrc_aws.txt' : 'bashrc.txt'
end

if !::File.exists?('/tmp/bashrc.txt')
    execute  "cat /tmp/bashrc.txt >> /etc/bashrc"
end
