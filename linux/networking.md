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
```
1. route -n
2. ip route list
3. netstat –rn  { equivalent to cat /proc/net/route }
```

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

5) Setting an IP address:

To set the IP address 10.10.10.2 to a network interface (eth0):
```
ifconfig eth0 10.10.10.2 netmask 255.255.255.0  broadcast 10.10.10.255 up
route add default gw 10.10.10.1
```

To restart the networking by entering the following commands:
```
ifdown eth0 , or ifconfig eth0 down
ifup eth0 , or ifconfig eth0 up
```

To restart all the interfaces
```
service network restart
/etc/init.d/network restart
```

To confirm the IP address is in place:
```
# ifconfig eth0 , or ifconfig -a eth0
# ifconfig | grep "inet " | egrep -v "127.0.0.1"
```

You can check the system log /var/log/messages to make sure the network interfaces are functioning.

6) Ping test:
To test pinging from a specific interface:
```
# ping  58.162.139.65 -I eth1
```

7) To change the MAC address:
Assuming you want to change the MAC id for eth0:
```
# ifconfig eth0 down  
# ifconfig eth0 hw ether 00:00:00:00:00:00      (choose your mac here)
# ifconfig eth0 up
```

8) To display the list of arp tables:
```
# arp -an
```

9) To display the speed of the network:
```
# ethtool eth0
```

10) To find out the gateway used for routing:
```
# ip route get 144.130.49.54
```


Networking related files:
-------------------------
1) DNS file: /etc/resolv.conf
It contains the details of nameserver i.e details of your DNS server which helps us connect to Internet

You can specify the list of DNS/name server(s) in /etc/resolv.conf file:
```
nameserver 8.8.8.8
nameserver 8.8.4.4
```

2) Default gateway: /etc/sysconfig/network 
```
NETWORKING=yes 
HOSTNAME=hostname.domainname 
GATEWAY=10.10.10.1 
NETWORKING_IPV6=yes 
IPV6_AUTOCONF=no
```

Route all traffic via 192.168.1.254 gateway connected via eth0 network interface. The following command will set a default gateway for both internal and external network (if any):
```
# route add default gw 192.168.1.254 eth0  , or
# ip route add 192.168.1.0/24 dev eth0
```

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
```
192.168.200.0/24 via 0.0.0.0 dev eth1

echo '10.0.0.0/8 via 10.8.2.65' >> /etc/sysconfig/network-scripts/route-eth0
```
If you need to add it from command line:

To add static route using “route add” in command line:
```
# route add -net 192.168.100.0 netmask 255.255.255.0 gw 192.168.10.1 dev eth0
```
To add static route using “ip route” command:
```
# ip route add 192.168.100.0/24 via 192.168.10.1 dev eth1
```

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
