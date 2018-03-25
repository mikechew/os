## Setup Tasks:

rsync (stands for remote sync) is a utility that can be used to synchronise the files and directories from one location to another in an effective manner.

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

# Examples:
 ```
# If you want to copy only php files from one server to another, you can use this command.
# rsync ‐av ‐‐include='*/' ‐‐include='*.php' ‐‐exclude='*' source-server destination-server

# Now if you want to copy only css and js files, use this command:
# rsync ‐av ‐‐include='*/' ‐‐include='*.js' ‐‐include'*.css' ‐‐exclude='*' source-server destination-server

# Exclude a single file
# rsync ‐avz ‐‐exclude 'file' source/ destination/

# Exclude a type of files
# rsync ‐avz ‐‐exclude '*.typ' source/ destination/

# Exclude a folder
# rsync ‐avz ‐‐exclude 'folder' source/ destination/

# Exclude multiple files or folders
# rsync ‐avz ‐‐exclude '*.file_type' ‐‐exclude 'folder' source/ destination/

# backup.tar needs to be copied or synced to /tmp/backups/ folder
# rsync -zvh backup.tar /tmp/backups/

# Displays the progress while transferring the data from one machine to a different machine using the ‘–progress’ option.
# rsync -avzhe ssh --progress /home/rpmpkgs root@192.168.0.100:/root/rpmpkgs

# Use ‘–delete‘ option to delete files that are not there in source directory
# rsync -avz --delete root@192.168.0.100:/var/lib/rpm/ .

# Use the Max file size to be transferred or sync using the “–max-size” option.
# rsync -avzhe ssh --max-size='200k' /var/lib/rpm/ root@192.168.0.100:/root/tmprpm

# To automatically delete source files after successful transfer
# rsync --remove-source-files -zvh backup.tar /tmp/backups/

# To perform a dry run of the command and shows the output of the command using the ‘–dry-run‘ option
# rsync --dry-run --remove-source-files -zvh backup.tar /tmp/backups/

#  To set the bandwidth limit while transferring data from one machine to another machine using the ‘–bwlimit‘ option. 
# rsync --bwlimit=100 -avzhe ssh  /var/lib/rpm/  root@192.168.0.100:/root/tmprpm/

# By default rsync syncs changed blocks and bytes only, if you want explicitly want to sync whole file using the ‘-W‘ option
# rsync -zvhW backup.tar /tmp/backups/backup.tar
```
