## Overview

```
# install-cifs.sh

yum -y update
yum -y install cifs-utils
nmap -p T:139 10.65.5.191

yum -y install telnet
telnet 10.65.5.191 139

yum -y install nc
nc -vn 10.65.5.191 139 -w 1 1
# Connection to 10.65.5.191 139 port [tcp/*] succeeded!

mkdir -p /data/cifs/win

mount -t cifs //10.65.5.191/temp /data/cifs/win/ -o user=actifio,pass=password
# nohup ./install-cifs.sh > install-cifs.log 2> install-cifs.err &

```

umount /data/cifs/win
