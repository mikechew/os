## Overview

# Install CentOS OS
```
$ThisHost=centosA
$ThisIP=10.65.5.205

# Modify /etc/sysconfig/network

# Modify /etc/sysconfig/network-scripts/ifcfg-eth0 

# Update .bash_profile for the root user
echo "export LC_ALL=en_US" >> .bash_profile

echo "session required pam_limits.so" >> /etc/pam.d/login

# Update DNS
echo "nameserver 10.61.5.161" >> /etc/resolv.conf

# Update hosts file
echo "$ThisIP $ThisHost" >> /etc/hosts

sed -i -e 's/^SELINUX=enforcing/#SELINUX=enforcing/' /etc/selinux/config
echo "SELINUX=disabled" >> /etc/selinux/config

route -n
service iptables stop
hostname $ThisHost
reboot

```

# Prepare OS for installation

```
cd /etc/yum.repos.d
wget https://public-yum.oracle.com/public-yum-ol6.repo --no-check-certificate
ping www.google.com
wget https://public-yum.oracle.com/public-yum-ol6.repo --no-check-certificate
wget https://public-yum.oracle.com/RPM-GPG-KEY-oracle-ol6 -O /etc/pki/rpm-gpg/RPM-GPG-KEY-oracle --no-check-certificate
yum -y install oracle-rdbms-server-11gR2-preinstall

hostname
swapon -s
ping www.google.com
yum -y install xorg-x11-xauth xorg-x11-apps xorg-x11-fonts-* xorg-x11-utils
xclock


yum -y install ntp
chkconfig ntpd on
                
/etc/init.d/ntpd start
/etc/init.d/ntpd stop
/etc/init.d/ntpd status

cat /etc/sysconfig/ntpd
# Drop root to id 'ntp:ntp' by default.
SYNC_HWCLOCK=no

vi /etc/sysconfig/ntpd
echo "server 0.centos.pool.ntp.org iburst" >> /etc/ntp.conf 
echo "server 1.centos.pool.ntp.org iburst" >> /etc/ntp.conf 
echo "server ntp.server.com" >> /etc/ntp.conf 
echo "server 10.10.10.1" >> /etc/ntp.conf    
echo 'OPTIONS="-x -u ntp:ntp -p /var/run/ntpd.pid -g"' >> /etc/sysconfig/ntpd  
                
chkconfig ntpd off
service ntpd restart
iptables -A OUTPUT -p udp --dport 123 -j ACCEPT

/usr/sbin/ntpq –pn
ping –c 2 www.google.com

service ntpd restart
service ntpd status
service ntpd restart
```

# Create Oracle users and directory
```
useradd oracle -u 550

# Set the Oracle userID password to password
echo -e "password\npassword" | passwd oracle
/usr/sbin/groupadd -g 500 oinstall
/usr/sbin/groupadd -g 501 dba
/usr/sbin/groupadd -g 502 oper
/usr/sbin/groupadd -g 503 asmdba
/usr/sbin/groupadd -g 504 asmadmin
/usr/sbin/groupadd -g 505 asmoper

/usr/sbin/usermod -g oinstall -G dba,asmdba,asmadmin oracle

mkdir -p /u01/app/oracle
chown -R oracle:oinstall /u01/app
chmod -R 775 /u01/app
ls -ld /u01/app
su - oracle

Install grid

cat .bash_profile
echo "# Grid" >> .bash_profile
echo "export ORACLE_BASE=/u01/app/oracle/" >> .bash_profile
echo "export ORACLE_HOME=/u01/app/11.2.0/grid" >> .bash_profile
echo "# Oracle software" >> .bash_profile
echo "# export ORACLE_HOME=$ORACLE_BASE/product/11.2.0/dbhome_1" >> .bash_profile
echo "export ORACLE_HOSTNAME=melnaborcl" >> .bash_profile
echo "export TMP=/tmp" >> .bash_profile
echo "export TMPDIR=/tmp" >> .bash_profile
echo "unset ORACLE_SID" >> .bash_profile
echo "export PATH=\$ORACLE_HOME/bin:\$PATH" >> .bash_profile
cat .bash_profile
```

# Mount the Oracle software and modify the cvu_config file
```
yum -y install cifs-utils
mkdir /software
useradd -u 5000 svc_library_core
groupadd -g 6000 share_library_core
usermod -G share_library_core -a root
mkdir /lib_core
mount.cifs //10.61.5.162/public /lib_core -o user=administrator,uid=5000,gid=600
cd /software
unzip /lib_core/ORACLE/p13390677_112040_Linux-x86-64_1of7.zip
unzip /lib_core/ORACLE/p13390677_112040_Linux-x86-64_2of7.zip
unzip /lib_core/ORACLE/p13390677_112040_Linux-x86-64_3of7.zip
umount /lib_core
sed -i -e 's/^CV_ASSUME_DISTID=OEL4/CV_ASSUME_DISTID=OEL6/' /software/grid/stage/cvu/cv/admin/cvu_config
sed -i -e 's/^CV_ASSUME_DISTID=OEL4/CV_ASSUME_DISTID=OEL6/' /software/database/stage/cvu/cv/admin/cvu_config
```

# Install the ASM driver and add disks
```
ping -c 2 www.oracle.com
yum -y install oracleasm-support kmod-oracleasm
cd /lib_core
curl -O http://download.oracle.com/otn_software/asmlib/oracleasmlib-2.0.12-1.el6.x86_64.rpm
rpm -ivh oracleasmlib-2.0.12-1.el6.x86_64.rpm


echo -e "oracle\noinstall\ny\ny\n" | oracleasm configure -i
rpm -qa | grep oracleasm

/etc/init.d/oracleasm start
oracleasm listdisks
oracleasm scandisks

smartctl --scan
ls /dev/sd*
grep mpt /sys/class/scsi_host/host?/proc_name
echo "- - -" > /sys/class/scsi_host/host2/scan
grep mpt /sys/class/scsi_host/host?/proc_name
ls /dev/sd*
smartctl --scan
echo -e "n\np\n1\n\n\nw" | fdisk /dev/sdb 
echo -e "n\np\n1\n\n\nw" | fdisk /dev/sdc

/etc/init.d/oracleasm deletedisk DATA
/etc/init.d/oracleasm createdisk DATA1 /dev/sdb1
/etc/init.d/oracleasm createdisk DATA2 /dev/sdc1
oracleasm listdisks
```

# Install the Oracle software
```
cp .Xauthority /home/oracle 
chown oracle:oinstall /home/oracle/.Xauthority
chmod 600 /home/oracle/.Xauthority
su - oracle
cd /software/grid
./runInstaller

Unix:
$ cd /11gR2/database
$ ./runInstaller silent
debug
force
\
FROM_LOCATION=/11gR2/database/stage/products.xml \
oracle.install.option=INSTALL_DB_SWONLY \
UNIX_GROUP_NAME=oinstall \
INVENTORY_LOCATION=/u01/app/oracle/oraInventory \
ORACLE_HOME=/u01/app/oracle/product/11201/db_1 \
ORACLE_HOME_NAME="OraDb11g_Home1" \
ORACLE_BASE=/u01/app/oracle \
oracle.install.db.InstallEdition=EE \
oracle.install.db.isCustomInstall=false \
oracle.install.db.DBA_GROUP=dba \
oracle.install.db.OPER_GROUP=dba \
DECLINE_SECURITY_UPDATES=true



cp <unzip_location>/database/response/db_install.rsp 

Response File:

oracle.install.responseFileVersion=/oracle/install/rspfmt_dbinstall_response_schema_v11_2_0
oracle.install.option=INSTALL_DB_SWONLY
ORACLE_HOSTNAME=server.domain
UNIX_GROUP_NAME=oinstall
kINVENTORY_LOCATION=/home/oracle/11202/inventory
SELECTED_LANGUAGES=en
ORACLE_HOME=/u01/oracle/products/11202
ORACLE_BASE=/u01/oracle/products
oracle.install.db.InstallEdition=EE
oracle.install.db.isCustomInstall=true
# This variable is considered only if 'IsCustomInstall' is set to true.
oracle.install.db.customComponents=oracle.server:11.2.0.1.0,oracle.sysman.ccr:10.2.7.0.0,oracle
.xdk:11.2.0.1.0,oracle.rdbms.oci:11.2.0.1.0,oracle.network:11.2.0.1.0,oracle.network.listener:1
1.2.0.1.0,oracle.rdbms:11.2.0.1.0,oracle.options:11.2.0.1.0,oracle.rdbms.partitioning:11.2.0.1.
0,oracle.oraolap:11.2.0.1.0,oracle.rdbms.dm:11.2.0.1.0,oracle.rdbms.dv:11.2.0.1.0,orcle.rdbms.l
bac:11.2.0.1.0,oracle.rdbms.rat:11.2.0.1.0
oracle.install.db.DBA_GROUP=oinstall
DECLINE_SECURITY_UPDATES=true


./runInstaller -silent -ignorePrereq -responseFile <complete_path>/db_install.rsp

```
