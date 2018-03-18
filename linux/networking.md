Overview
========

Basic Networking commands/setup:
--------------------------------
1) To change the hostname temporarily:
```
hostname server1
```
For a permanent change, modify /etc/sysconfig/network
```
NETWORKING=yes
HOSTNAME=hostname.domainname

sed –i –e ‘/^HOSTNAME/d’ /etc/sysconfig/network
echo “HOSTNAME=saturn” >> /etc/sysconfig/network 
```

2) To change the timezone:
Find out the timezone you would like to set to:
```
ls -l /usr/share/zoneinfo/Australia/
```

Link the localtime to the new time-zone
```
ln -sfv /usr/share/zoneinfo/Australia/Melbourne /etc/localtime
```

Confirm the new time-zone is in place:
```
# date
```

3) To display the routing table:

Use the following to display the routing table:
* a) route -n
* b) ip route list
* c) netstat –rn  { equivalent to cat /proc/net/route }

4) To set date and time:

To set the new date and time:
```
# date -s "2 OCT 2006 18:00:00"
```

Or, set using the date format:
```
# date +%Y%m%d -s "20151128"
```

To set the hardware clock to the current system time:
```
# hwclock --systohc
```

To set the system time to the hardware clock:
```
# hwclock --hctosys
```

To display the hardware clock:
```
# hwclock --show
```

Networking related files:
-------------------------
1) DNS file: /etc/resolv.conf
It contains the details of nameserver i.e details of your DNS server which helps us connect to Internet

You can specify the list of DNS/name server(s) in /etc/resolv.conf file:

nameserver 8.8.8.8
nameserver 8.8.4.4

2) Default gateway: /etc/sysconfig/network 

NETWORKING=yes 
HOSTNAME=hostname.domainname 
GATEWAY=10.10.10.1 
NETWORKING_IPV6=yes 
IPV6_AUTOCONF=no

3) eth0/1/../n configuration file: /etc/sysconfig/network-scripts/ifcfg-eth0 

For static IP, use the following:
```
# eth0 configuration file
DEVICE=eth0 
BOOTPROTO=static
HWADDR=00:30:48:56:A6:2E
IPADDR=10.10.29.66
NETMASK=255.255.255.192
ONBOOT=yes
STARTMODE=onboot
NETWORK=192.168.109.0
BROADCAST=192.168.109.255
GATEWAY=192.168.109.1
```

If the interface has IP address assigned by DHCP:
```
DEVICE=eth0
BOOTPROTO=dhcp
HWADDR=00:05:29:E0:4F:3D
ONBOOT=yes
TYPE=Ethernet
```

4) static route: /etc/sysconfig/network-scripts/route-eth0 
```
default 192.168.109.1
default 192.168.109.1 dev eth1 
10.0.0.0/8 via 10.10.29.65 dev eth1
```
The below statement will send traffic to the subnet 192.168.200.0/24 via the eth1 interface. A null gateway (0.0.0.0) is used because this traffic will stay local to the LAN eth1 is connected to.
192.168.200.0/24 via 0.0.0.0 dev eth1

echo '10.0.0.0/8 via 10.8.2.65' >> /etc/sysconfig/network-scripts/route-eth0

Actifio integrating with Linux hosts:
-------------------------------------
On the source/target server:

Testing connectivity to the Actifio appliance:
```
[root@centosA ~]# nc -z -v 10.61.5.189 3260
Connection to 10.61.5.189 3260 port [tcp/iscsi-target] succeeded!

[root@centosA ~]# netstat -ano | grep 3260
tcp        0      0 10.61.5.190:42181           10.61.5.187:3260            ESTABLISHED off (0.00/0/0)

[root@centosA ~]# netstat -ano | grep 5106
tcp        0      0 0.0.0.0:5106                0.0.0.0:*                   LISTEN      off (0.00/0/0)
```


Testing connectivity from the Actifio appliance to Linux host:
```
[root@sky ~]# nc -z -v 10.61.5.190 5106
Connection to 10.61.5.190 5106 port [tcp/*] succeeded!

[root@sky ~]# netstat -ano | grep 3260
tcp        0      0 0.0.0.0:3260                0.0.0.0:*                   LISTEN      off (0.00/0/0)
tcp        0      0 10.61.5.189:3260            10.61.5.182:49851           ESTABLISHED keepalive (6.08/0/0)
tcp        0      0 10.61.5.189:57538           10.61.5.189:3260            ESTABLISHED off (0.00/0/0)
tcp        0      0 10.61.5.189:3260            10.61.5.189:57538           ESTABLISHED keepalive (11.76/0/0)
tcp        0      0 10.61.5.189:3260            10.61.5.201:49357           ESTABLISHED keepalive (5.60/0/0)
```

Testing connectivity from Mac to Actifio appliance:
```
~:$ netstat -an | grep 10.61.5.189.443
tcp4       0      0  10.61.5.14.55501       10.61.5.189.443        ESTABLISHED
tcp4       0      0  10.61.5.14.55015       10.61.5.189.443        ESTABLISHED
```
