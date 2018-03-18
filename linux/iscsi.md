Overview
========


Setting up iSCSI
----------------

On the Linux host, to install the iSCSI initiator packages:
```
# yum -y install iscsi-initiator-utils
```

To confirm the iSCSI package is installed:
```
rpm -qa | grep -i iscsi
```

To restart the iSCSI and iSCSI daemon services:
```
# service iscsi stop
# service iscsid stop

# service iscsid start
# service iscsi start
```

If iSCSI daemon is not running, you might need to try start it up with
```
# /etc/rc.d/init.d/iscsid force-start
```

```
# cat /var/log/messages | grep -i iscsi
```

To find out the IQN on the host:
```
# cat /etc/iscsi/initiatorname.iscsi
# grep -v ^# /etc/iscsi/initiatorname.iscsi | cut -d "=" -f 2
```

To set iscsi services to start on boot:
```
# chkconfig iscsid on 
# service iscsid start 
# chkconfig iscsi on 
# service iscsi start 
```
To list all the discovered nodes (current iSCSI IP address):
```
iscsiadm -m node
```

To scan the iscsi bus for LUNs:
```
iscsiadm -m node --rescan
```

To list the current sessions logged in:
```
iscsiadm -m session
```

To discover the iSCSI targets on the Actifio appliance:
```
iscsiadm –m discovery –t st –p ip.address.of.Actifio.iscsi.target 
```

To login to the iSCSI target on the Actifio appliance:
```
iscsiadm –m discovery -T <IQN from the above command> –t st –p ip.address.of.Actifio.iscsi.target --login
```


On the Actifio appliance (172.24.1.102), to discover the target name and portal value:
```
# iscsiadm -m discoverydb
172.24.1.102:3260 via sendtargets
172.24.1.151:3260 via sendtargets
# iscsiadm -m discovery -t st -p 172.24.1.102  
172.24.1.102:3260,1 iqn.1994-05.com.redhat:451b25aad8d6

```

To remove the target name and portal value from the database:
```
iscsiadm -m discoverydb -t st -o delete -p 172.24.1.102:3260
```

Note:  -t st can be substituted as --type st, and -p can be substituted as --portal

To log into target(s):
```
iscsiadm -m node -l
# iscsiadm -m node -T iqn.1994-05.com.redhat:451b25aad8d6 - 172.24.1.102 --login
# iscsiadm -m session 
tcp: [2] 172.24.1.102:3260,1 iqn.1994-05.com.redhat:451b25aad8d6
```

To log out of iSCSI sessions:
```
iscsiadm -m session -u
iscsiadm -m node -T iqn.1986-03.com.ibm -p 172.24.50.41 -u
# iscsiadm -m node -u
Logging out of session [sid: 2, target: iqn.1994-05.com.redhat:451b25aad8d6, portal: 172.24.1.102,3260]
Logout of [sid: 2, target: iqn.1994-05.com.redhat:451b25aad8d6, portal: 172.24.1.102,3260] successful.
# iscsiadm -m node   
172.24.1.102:3260,1 iqn.1994-05.com.redhat:451b25aad8d6
# iscsiadm -m session
iscsiadm: No active sessions.
```

```
# iscsiadm -m node -l
Logging in to [iface: default, target: iqn.1994-05.com.redhat:451b25aad8d6, portal: 172.24.1.102,3260] (multiple)
Login to [iface: default, target: iqn.1994-05.com.redhat:451b25aad8d6, portal: 172.24.1.102,3260] successful.
# iscsiadm -m session
tcp: [3] 172.24.1.102:3260,1 iqn.1994-05.com.redhat:451b25aad8d6 
```

List the nodes and discovery records:
```
ls /var/lib/iscsi
ls /var/lib/iscsi/send_targets
```


```
ls /dev/disk/
- by-id → based upon the serial number of the hardware devices
- by-label → Whatever name was set manually for this disk
- by-path → Maps from the path identifier to the current /dev/sd name.
- by-uuid → Universal Unique Identifier: a uniquely created string to identify the disk 

```
