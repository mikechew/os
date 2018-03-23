## Setup Tasks:

Following is the instructions on how to setup NFS client and server on the Linux host:

On the server:
```
# cat install-rsync.sh
yum -y update
yum -y install rsync
cat /etc/rsyncd.conf

# nohup ./install-rsync.sh > install-rsync.log 2> install-rsync.err &

# ll /tmp/p
total 0
-rw-r--r--. 1 501 root 0 Mar 23 00:09 a.txt
-rw-r--r--. 1 501 root 0 Mar 23 00:09 b.txt

```


On the client:
```

# ll /tmp/p
total 0
-rw-r--r--  1 michael  wheel     0B 23 Mar 15:09 a.txt
-rw-r--r--  1 michael  wheel     0B 23 Mar 15:09 b.txt
# rsync -avzh /tmp/p/* root@10.65.5.202:/tmp/p
root@10.65.5.202's password: 
building file list ... done
created directory /tmp/p
```
