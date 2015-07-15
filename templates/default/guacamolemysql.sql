#MySQL Guacamole Script

CREATE DATABASE <%=node['guacamole']['dbname'] %>;

CREATE USER '<%= node['guacamole']['dbuser'] %>'@'<%=node['guacamole']['dbhost']%>' IDENTIFIED BY '<%=node['guacamole']['dbpass']%>';

GRANT ALL ON *.* to '<%= node['guacamole']['dbuser']%>'@'<%=node['guacamole']['dbhost']%>' IDENTIFIED BY '<%=node['guacamole']['dbpass']%>';

FLUSH PRIVILEGES;

quit
