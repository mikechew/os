## How to install Apache server

The following is how you can setup the Apache server on Linux:

```
# install the Apache server
yum -y install httpd
rpm -qa | grep httpd

# start the web service
service httpd start

# or, 
/etc/init.d/httpd start

# Set to start automatically when the server is rebooted
chkconfig httpd on

# vi /etc/sysconfig/iptables
Add the following lines.

[...]
-A INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEP
[...]

# Apache runs on port 80, enable port 80
iptables -I INPUT -p tcp --dport 80 -j ACCEPT
# Saves the changes
service iptables save

# restart iptables:
service iptables restart
```
