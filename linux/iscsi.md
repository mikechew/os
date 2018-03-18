Overview
========


Setting up iSCSI
----------------

To install the iSCSI initiator packages:
```# yum -y install iscsi-initiator-utils```

To restart the iSCSI and iSCSI daemon services:
```# service iscsi stop
# service iscsid stop

# service iscsid start
# service iscsi start```

If iSCSI daemon is not running, you might need to try start it up with
```# /etc/rc.d/init.d/iscsid force-start```

```# cat /var/log/messages | grep -i iscsi```

To find out the IQN on the host:
```# cat /etc/iscsi/initiatorname.iscsi
# grep -v ^# /etc/iscsi/initiatorname.iscsi | cut -d "=" -f 2```

To set iscsi services to start on boot:

```# chkconfig iscsid on 
# service iscsid start 
# chkconfig iscsi on 
# service iscsi start ```
