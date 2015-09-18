#tomcat installation

package_url = node['tomcat']['url']
base_package_filename = File.basename(package_url)

remote_file "#{Chef::Config[:file_cache_path]}/#{base_package_filename}" do
  source package_url
  mode '0700'
  action :create_if_missing
end

package 'unzip'

bash 'tomcat_install' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
  unzip #{Chef::Config[:file_cache_path]}/#{base_package_filename}
  mv /tmp/apache-tomcat-8.0.26 /opt/tomcat
  EOH
  not_if {::File.directory?("/opt/tomcat")}
end

template "/etc/profile.d/tomcat.sh" do
  source "tomcat.sh.erb"
  mode '755'
  action :create_if_missing
end

template "/etc/init.d/tomcat" do
  source "tomcat.erb"
  mode "00755"
  variables(
    :java_home => node['java']['java_home']
  )
  not_if {File.exists?('/etc/init.d/tomcat')}
end

bash 'tomcat_env' do
  user 'root'
  code <<-EOH
  source /etc/profile.d/tomcat.sh
  chkconfig --add tomcat
  chmod +x $CATALINA_HOME/bin/startup.sh
  chmod +x $CATALINA_HOME/bin/shutdown.sh
  chmod +x $CATALINA_HOME/bin/catalina.sh
  EOH
end

template "/opt/tomcat/conf/tomcat-users.xml" do
  source "tomcat-users.xml.erb"
  mode "00755"
end

