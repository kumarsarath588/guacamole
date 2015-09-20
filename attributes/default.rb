
# Java Attributes
override['java']['jdk_version'] = '7'
override['java']['oracle']['accept_oracle_download_terms'] = true
override['java']['accept_license_agreement'] = true

# Tomcat attributes.
default['tomcat']['version'] = 8
default['tomcat']['user'] = 'admin'
default['tomcat']['pass'] = 'admin'
default['tomcat']['home'] = '/opt/tomcat'
default['tomcat']['url'] = 'http://mirrors.gigenet.com/apache/tomcat/tomcat-8/v8.0.26/bin/apache-tomcat-8.0.26.zip'

# guacamole attributes
default['guacamole']['libtelnet']['url'] = 'http://dl.fedoraproject.org/pub/epel/6/x86_64/libtelnet-0.20-2.el6.x86_64.rpm'
default['guacamole']['libtelnet_devel']['url'] = 'http://dl.fedoraproject.org/pub/epel/6/x86_64/libtelnet-devel-0.20-2.el6.x86_64.rpm'
default['guacamole']['dbhost'] = 'localhost'
default['guacamole']['dbport'] = 3306
default['guacamole']['dbuser'] = 'guacamole_user'
default['guacamole']['dbpass'] = 'guacamole'
default['guacamole']['dbname'] = 'guacamole_db'
default['guacamole']['libdir'] = '/var/lib/guacamole/classpath'
