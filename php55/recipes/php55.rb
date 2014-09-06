case node['platform']
when 'redhat', 'centos'
    options = "--enablerepo=remi-php55,remi"
when 'amazon'
    package "php*" do
        action :remove
    end
    options = "--enablerepo=remi-php55,remi --disablerepo=amzn-updates,amzn-main"
end
%w{php php-pear php-mbstring php-xml php-devel php-gd php-mysql php-mcrypt php-fpm php-pecl-mongo}.each do |pkg|
    package pkg do
        options options
        action :install
    end
end
case node['platform']
when 'redhat', 'centos'
    %w{php-pecl-imagick}.each do |pkg|
        package pkg do
            options options
            action :install
        end
    end
when 'amazon'
    package "ImageMagick-devel"
    php_pear "imagick" do
        action :install
    end
end
