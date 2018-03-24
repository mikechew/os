## Setup Tasks:

rsync is a utility that can be used to synchronise the files and directories from one location to another in an effective manner.

Following is the instructions on how to setup rsync software on the Linux host:

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

# rsync -avz /tmp/foo/ root@host2:/tmp/bar 
# rsync -avh -e "ssh -p 22" root@10.10.10.1:/tmp/bar/*.csv . 
# rsync -avh -e "ssh -p 26 -A -i /Users/john/.ssh/id_rsa" list.sh 10.10.10.1:/tmp/bar
```

# Syntax:
rsync options source destination
```
 -r – recursive for moving directories. 
 -z – compress file data. 
 -v – verbose (try -vv for more detailed information) 
 -e "ssh options" : specify the ssh as remote shell 
 -a – archive mode, combo of -rlptgoD, meaning: "preserves" symbolic links, special and 
 	device files, modification times, group, owner, and permissions. 
 -P – combo of --progress and --partial, meaning it shows a progress bar and it’s 
 	possible to resume interrupted transfers. 
 --delete – delete files that don’t exists in source (sender) system, good when syncing.
 ```
