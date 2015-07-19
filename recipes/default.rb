#
# Cookbook Name:: guacamole
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#Guacamole installation

#Package installation


apt_repository 'libssh2' do
   uri        'http://kr.archive.ubuntu.com/ubuntu'
   components ['main', 'universe']
   distribution 'trusty'
   only_if { node['platform']=="ubuntu" }
end

if node['platform']=="ubuntu" 
  include_recipe "apt"
end

include_recipe "java"

package ['cairo-devel', 'libpng-devel', 'uuid-devel', 'freerdp-devel', 'pango-devel', 'libssh2-devel', 'libvncserver-devel', 'pulseaudio-libs-devel', 'openssl-devel', 'libvorbis-devel', 'wget', 'unzip', 'gcc', 'gcc-c++', 'libpng-devel', 'cairo-devel', 'uuid-devel' ] do
    action :install
    only_if { node['platform']=="centos" or node['platform']=="amazon" }
end

package ['libcairo2-dev', 'libpng12-dev', 'libossp-uuid-dev', 'libfreerdp-dev', 'libpango1.0-dev', 'libtelnet-dev', 'libssh2-1-dev', 'libvncserver-dev', 'libpulse-dev', 'libssl-dev', 'libvorbis-dev', 'gcc', 'unzip', 'wget', 'g++' ] do
    action :install
    only_if { node['platform']=="ubuntu" }
end

libtelnet_url = node['guacamole']['libtelnet']['url']
libtelnet_devel_url = node['guacamole']['libtelnet_devel']['url']
libtelnet_filename = File.basename(libtelnet_url)
libtelnet_devel_filename = File.basename(libtelnet_devel_url)

remote_file "#{Chef::Config[:file_cache_path]}/#{libtelnet_filename}" do
  source libtelnet_url
  mode '0700'
  action :create_if_missing
end

remote_file "#{Chef::Config[:file_cache_path]}/#{libtelnet_devel_filename}" do
  source libtelnet_devel_url
  mode '0700'
  action :create_if_missing
end

bash 'libtelnet' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
  [ -z "$(rpm -qa|grep libtelnet)" ] && rpm -ivh libtelnet-0*.rpm || exit 0
  EOH
  only_if { node['platform']=="centos" or node['platform']=="amazon" }
end

bash 'libtelnet' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
  [ -z "$(rpm -qa|grep libtelnet-devel)" ] && rpm -ivh libtelnet-devel-0*.rpm || exit 0
  EOH
  only_if { node['platform']=="centos" or node['platform']=="amazon" }
end


include_recipe "guacamole::tomcat"

magic_shell_environment 'LD_LIBRARY_PATH' do
  value "/usr/local/lib"
  only_if { node['platform']=="ubuntu" }
end

bash 'guacamole_server' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
  if [ -f /etc/profile.d/jdk.sh ] ; then source /etc/profile.d/LD_LIBRARY_PATH.sh ; fi
  wget http://sourceforge.net/projects/guacamole/files/current/source/guacamole-server-0.9.7.tar.gz/download -O guacamole-server-0.9.7.tar.gz
  tar -zxf guacamole-server-0.9.7.tar.gz
  cd guacamole-server-0.9.7
  ./configure --with-init-dir=/etc/init.d
  make
  make install
  EOH
  not_if {File.exists?("/etc/init.d/guacd")}
end

service "guacd" do
  action [ :enable, :start ]
end

%w[ /var/lib/guacamole/classpath /root/.guacamole ].each do |dir|
  directory "#{dir}" do
    owner 'root'
    group 'root'
    mode '0755'
    recursive true
    action :create
  end
end

bash 'guacamole_war' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
  wget http://sourceforge.net/projects/guacamole/files/current/binary/guacamole-0.9.7.war/download -O guacamole-0.9.7.war
  cp guacamole-0.9.7.war /opt/tomcat/webapps/guacamole.war
  EOH
  not_if {File.exists?("/opt/tomcat/webapps/guacamole.war")}
end

service "tomcat" do
  action [ :restart ]
end

template "/root/.guacamole/guacamole.properties" do
  source "guacamole.properties.erb"
end

%w[ guacamole-auth-jdbc-mysql-0.9.7.jar mysql-connector-java-5.1.35-bin.jar ].each do |file|
  cookbook_file "/var/lib/guacamole/classpath/#{file}" do
   source "#{file}"
    action :create_if_missing
  end
end

if node['platform'] == "centos" && node['platform_version'].to_f >= 7.0
  package [ 'mariadb-server' , 'mariadb' ] do
    action :install
  end
  service "mariadb" do
    supports :restart => true, :reload => true
    action [:enable, :start]
  end
else
  package "mysql-server" do
    action :install
  end
  case node["platform_family"]
   when "debian"
     mysql_service="mysql"
   when "rhel"
     mysql_service="mysqld"
  end

  service mysql_service do
    supports :restart => true, :reload => true
    action [:enable, :start]
  end
end


template "/tmp/guacamolemysql.sql" do
  source "guacamolemysql.sql"
  mode "00755"
end

cookbook_file '/tmp/initdb.sql' do
  source 'initdb.sql'
  mode "00755"
end

bash 'guacamole_db_create' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
  mysql -u root < guacamolemysql.sql
  mysql -u root guacamole_db < initdb.sql
  EOH
 not_if{" mysql -u root -e 'show databases' | grep guacamole_db "}
end

service "tomcat" do
  action [ :enable, :start ]
end
