## Setup Tasks:

Following is the instructions on how to setup NFS client and server on the Linux host:

On the server:
```
# cat install-rsync.sh
yum -y update
yum -y install rsync
cat /etc/rsyncd.conf

# nohup ./install-rsync.sh > install-rsync.log 2> install-rsync.err &
```


On the client:
