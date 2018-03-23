## Setup Tasks:

Following is the instructions on how to setup NFS client and server on the Linux host:

On the server:
```
# cat install-nfs.sh 
# install NFS
yum -y install nfs-utils nfs-utils-lib

chkconfig nfs on 
service rpcbind start
service nfs start
chkconfig --levels 235 nfs on 


mkdir -p /data/nfs
chown 65534:65534 /data/nfs
chmod 755 /data/nfs

touch /data/nfs/readme.txt

cat /etc/exports
echo "/data/nfs  *(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
cat /etc/exports

exportfs -a

# nohup ./install-nfs.sh > install-nfs.log 2> install-nfs.err &
```

On the client:
```
yum -y update
yum -y install nfs-utils nfs-utils-lib
mkdir -p /tmp/nfs
mount 10.65.5.202:/data/nfs /tmp/nfs
umount /tmp/nfs
```

### Additional Information
```
chkconfig nfs on

service nfs start
service rpcbind start

service rpcbind status
service nfs status

cat /etc/sysconfig/nfs
cat /etc/idmapd.conf



mount

# vi /etc/exports

Add the entry as shown below.
/var/unixmen_share/     192.168.1.0/24(rw,sync,no_root_squash,no_all_squash)

where,
/var/unixmen_share  – shared directory
192.168.1.0/24      – IP address range of clients
rw                  – Writable permission to shared folder
sync                – Synchronize shared directory
no_root_squash      – Enable root privilege
no_all_squash       – Enable user’s authority
```
