Overview
========


Setting up iSCSI
----------------

On the Linux host, to install the iSCSI initiator packages (aka client)
** use the –y option if you do not want to be prompted during the install:
```
# yum -y install iscsi-initiator-utils
```
Or, using the rpm utility:
-i : install a package ; -v : verbose ; -h : print hash masks as the package archive is unpacked
```
rpm –ivh iscsi-initiator-utils-6.2.0.865-6.el5.x86_64.rpm 
```

To confirm the iSCSI initiator package is installed:
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

To find out the IQN name for the initiator on the host:
```
# cat /etc/iscsi/initiatorname.iscsi
InitiatorName=iqn.1994-05.com.redhat:38de7b36a09c
# grep -v ^# /etc/iscsi/initiatorname.iscsi | cut -d "=" -f 2
```
Or, run the command:
```
/sbin/iscsi-iname
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
# iscsiadm -m node
```

Lists the entries and remove them from the iSCSI database:
```
# iscsiadm -m discoverydb 
172.24.50.121:3260 via sendtargets
172.24.50.5:3260 via sendtargets
# iscsiadm -m discoverydb -t st -o delete -p 172.24.50.121:3260
# iscsiadm -m discoverydb
172.24.50.5:3260 via sendtargets
# iscsiadm -m discoverydb -t st -o delete -p 172.24.50.5:3260
# iscsiadm -m discoverydb

		* (-t st can be substituted as --type st, and -p can be substituted as --portal)
```

To view the iSCSI status of the discovered targets: 
```
iscsiadm --mode node 
```

To rescan the iSCSI bus for LUNs (in case there are changes to the LUN):
```
# iscsiadm -m node --rescan
iscsiadm: No session found.
```

To list the current sessions logged in (host has logged into Actifio & maintained its sessions)::
```
iscsiadm -m session
```

To discover the iSCSI targets (aka servers) on the Actifio appliance:
```
iscsiadm –m discovery –t st –p ip.address.of.Actifio.iscsi.target 
# iscsiadm -m discovery -t st -p 172.17.183.212
172.17.183.212:3260,1 iqn.1994-05.com.redhat:38de7b36a09c
10.82.18.52:3260,1 iqn.1994-05.com.redhat:38de7b36a09c
# iscsiadm -m node
172.17.183.212:3260,1 iqn.1994-05.com.redhat:38de7b36a09c
10.82.18.52:3260,1 iqn.1994-05.com.redhat:38de7b36a09c
```

From the host, to login to the iSCSI target on the Actifio appliance:
```
iscsiadm –m discovery -T <IQN from the above command> –t st –p ip.address.of.Actifio.iscsi.target --login
```

To verify the session is established:
```
iscsiadm –m session --op show
```

On the Actifio appliance (172.24.1.102), to discover the target name and portal value in the discoverydb database:
```
# iscsiadm -m discoverydb
172.24.1.102:3260 via sendtargets
172.24.1.151:3260 via sendtargets
# iscsiadm -m discovery -t st -p 172.24.1.102  
172.24.1.102:3260,1 iqn.1994-05.com.redhat:451b25aad8d6

```

To discover the loop back iscsi target. If the local loop back is listed then ISCSI target configuration is correct and working.
```
# iscsiadm –m discovery –t st –p <ip address of sky> 
```

To remove the target name and portal value from the iSCSI discovery database:
```
iscsiadm -m discoverydb -t st -p 172.24.1.102:3260 -o delete 
```

Note:  -t st can be substituted as --type st, and -p can be substituted as --portal

To mount a volume or log into target(s):
```
iscsiadm -m node -l
# iscsiadm -m node -T iqn.1994-05.com.redhat:451b25aad8d6 -p 172.24.1.102 --login
# iscsiadm -m session 
tcp: [2] 172.24.1.102:3260,1 iqn.1994-05.com.redhat:451b25aad8d6
```

To unmount (-u is to unmount) a volume or log out of iSCSI sessions:
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

To log out of iSCSI sessions and delete the cache (remove the node), prevent the session from re-establishing:
```
# iscsiadm -m node -T iqn.1986-03.com.ibm -p 172.24.50.41 -o delete

# ls /var/lib/iscsi/nodes/<iqn>
If the IQN exists, it should be deleted. Remove any entries that are stale from /var/lib/iscsi/send_targets/, /dev/disk/by-scsibus/ and /dev/disk/by-scsid/ directory as well.
```

```
# iscsiadm -m node -l
Logging in to [iface: default, target: iqn.1994-05.com.redhat:451b25aad8d6, portal: 172.24.1.102,3260] (multiple)
Login to [iface: default, target: iqn.1994-05.com.redhat:451b25aad8d6, portal: 172.24.1.102,3260] successful.
# iscsiadm -m session
tcp: [3] 172.24.1.102:3260,1 iqn.1994-05.com.redhat:451b25aad8d6 
```

iSCSI store caching information in /var/lib/scsi directory. 
To remove the nodes cache:
```
rm –rf /var/lib/iscsi/nodes/*
```
To remove the send_targets (directory contains the discovered targets) cache:
```
rm –rf /var/lib/iscsi/send_targets/*
```
If the above doesn’t work, reboot the system.


List the nodes and discovery records/targets database (files are located in /var/lib/iscsi):
```
ls /var/lib/iscsi
/var/lib/iscsi/nodes/          -- This directory contains the nodes with their targets.
/var/lib/iscsi/send_targets    -- This directory contains the portals.
```

```
ls /dev/disk/
- by-id         → based upon the serial number of the hardware devices
- by-label      → Whatever name was set manually for this disk
- by-path       → Maps from the path identifier to the current /dev/sd name.
- by-uuid       → Universal Unique Identifier: a uniquely created string to identify the disk 

```

To display SCSI attached device:
```
cat /proc/scsi/scsi
```

To find out the block devices of the iSCSI LUN:
```
tail /var/log/messages to find out the /dev/sd? device name 
```

To find a list of host symbolic links pointing to the iSCSI devices configured:
```
ls –l /sys/class/scsi_host/
```

To list all the SCSI disks on the host:
```
ls –l /sys/class/scsi_disk
```

To list all the block devices (disks) in the system by listing the files in /sys/block:
```
ls -al /sys/block/sd*
```
Note: sd : SCSI disk

The by-path one is the IQN of the device, and I presume that the by-id one is a SCSI device identifier.
```
ls -l /dev/disk/by-path/ip-* /dev/disk/by-id/scsi-*
```

List the devices by UUID: 
```
ls -l /dev/disk/by-uuid
ls -l /dev/disk/by-path
ls -l /dev/disk/by-scsibus/
```

blkid can be used to display information about block devices:
```
blkid /dev/sde
```
Note: UUID (Universal Unique Identifier)
```
fdisk –l /dev/sde
```

To view the block device, use the lsblk command:
```
lsblk
```

```
cat /proc/partitions
awk '/sd[a-z]$/{printf "%s %8.2f GiB\n", $NF, $(NF-1) / 1024 / 1024}' /proc/partitions
```

blockdev --getsize64 /dev/sda returns size in bytes.

To find out the size of the hard disk (This gives you its size in 512-byte blocks.):
```
cat /sys/block/sda/size
lsblk -a /dev/sde
```

To list only parent block IDs, and exclude the ROM/RAM (11,1)
```
lsblk –d –e 11,1
```

List block IDs in topology and information about file-system respectively:
```
lsblk –t –e 11,1
lsblk –f –e 11,1 
```

On some hosts, you can use smartctl to manage the disks:
```
smartctl  --scan
smartctl –a /dev/sdg
```
yum install smartmontools or apt-get install smartmontools to install smartctl tool.

###lsscsi

lsscsi is a useful tool to list all SCSI devices and hosts attached to the server. To install it on RHEL/CentOS, run:
```
yum install lsscsi
```
On Debian/Ubuntu, we will use the following command:
```
apt-get install lsscsi
```

lsscsi –c command is similar to cat /proc/scsi/scsi 

To view generic device node name:
```
lsscsi -d
```
To view it in long format:
```
lsscsi -l
```
To view the size of the SCSI disks:
```
lsscsi -s
```
To view the iSCSI related information on the SCSI disks:
```
lsscsi –t
lsscsi –t -H
```
To view generic information:
```
lsscsi -g
```

scstadmin is a useful tool to manage iSCSI target packages. To list all open iSCSI sessions:
```
scstadmin –list_sessions | grep –i session 
```

Perform a login back to itself:
```
iscsiadm -m discovery -t st -p 172.24.1.102
```

To find out the Sky IQN:
```
scstadmin –list_target
```
To list the LUNs presented by Sky:
```
scstadmin –list_group
```
To display the configuration:
```
scstadmin -write_config /dev/tty
```
To display the IQNs for each host in Sky:
```
/act/postgresql/bin/psql actdb act -c "select * from hbadata"  
```

Make sure the ports 5106 and 56789 are open on the Linux host:
```
telnet < ip-Linux_Windows_host > 3260
```
You should get a message “Connected to” if the port is open.
Ctrl-Z to kill the session

```
nc < ip-Linux_Windows_host > 3260 </dev/null ; echo $?
```
The above returns 0, which means the port is open

```
nc –z < ip-Linux_Windows_host > 3260
```
reports on open ports, rather than initiate a connection

## Uninstall packages

To list the installed package:
```
yum list installed | grep iscsi
iscsi-initiator-utils.x86_64
```

To remove (erase) the iscsi initiator package, run:
```
yum remove iscsi-initiator-utils , or 
yum erase iscsi-initiator-utils
```

Find out the exact package name
```
rpm -qa | grep -i iscsi
```
iscsi-initiator-utils-6.2.0.872-10.el5
Note: -qa : query all information

To uninstall the package:
```
rpm –e iscsi-initiator-utils-6.2.0.872-10.el5
```
Note: -e : erase (remove) package
