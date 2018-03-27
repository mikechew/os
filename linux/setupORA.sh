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
yum -y install wget
cd /etc/yum.repos.d
wget https://public-yum.oracle.com/public-yum-ol6.repo --no-check-certificate
ping -c 2 www.google.com
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
echo "export ORACLE_BASE=/u01/app/oracle" >> .bash_profile
echo "export ORACLE_HOME=$ORACLE_BASE/11.2.0/grid" >> .bash_profile
echo "# Oracle software" >> .bash_profile
echo "# export ORACLE_HOME=$ORACLE_BASE/11.2.0/dbhome_1" >> .bash_profile
echo "export ORACLE_HOSTNAME=melnaborcl" >> .bash_profile
echo "export TMP=/tmp" >> .bash_profile
echo "export TMPDIR=/tmp" >> .bash_profile
echo "unset ORACLE_SID" >> .bash_profile
echo "export PATH=\$ORACLE_HOME/bin:\$PATH" >> .bash_profile
cat .bash_profile
```

# Mount the Oracle software and modify the cvu_config file
```
yum -y install cifs-utils unzip
mkdir /software
useradd -u 5000 svc_library_core
groupadd -g 6000 share_library_core
usermod -G share_library_core -a root
mkdir /lib_core
mount.cifs //10.65.5.191/temp/iso /lib_core -o user=actifio,uid=5000,gid=600
cd /software
unzip /lib_core/p13390677_112040_Linux-x86-64_1of7.zip
unzip /lib_core/p13390677_112040_Linux-x86-64_2of7.zip
unzip /lib_core/p13390677_112040_Linux-x86-64_3of7.zip
umount /lib_core
sed -i -e 's/^CV_ASSUME_DISTID=OEL4/CV_ASSUME_DISTID=OEL6/' /software/grid/stage/cvu/cv/admin/cvu_config
sed -i -e 's/^CV_ASSUME_DISTID=OEL4/CV_ASSUME_DISTID=OEL6/' /software/database/stage/cvu/cv/admin/cvu_config
cd
```

# Install the ASM driver and add disks
```
ping -c 2 www.oracle.com
yum -y install oracleasm-support kmod-oracleasm
cd /lib_core
curl -O http://download.oracle.com/otn_software/asmlib/oracleasmlib-2.0.12-1.el6.x86_64.rpm
rpm -ivh oracleasmlib-2.0.12-1.el6.x86_64.rpm

# /etc/init.d/oracleasm or /usr/sbin/oracleasm
oracleasm status
echo -e "oracle\noinstall\ny\ny\n" | /etc/init.d/oracleasm configure -i
rpm -qa | grep oracleasm
oracleasm status

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
echo -e "\n\np\n1\n\n\nw" | fdisk /dev/sdb 
echo -e "\n\np\n1\n\n\nw" | fdisk /dev/sdc
ls /dev/sd*

# /etc/init.d/oracleasm deletedisk DATA
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
cd 

cp /software/grid/response/grid_install.rsp /home/oracle/grid.rsp
cp /software/database/response/db_install.rsp /home/oracle/db_install.rsp

sed -e '/^$/d' -e '/^ $/d' -e '/^#/d' /home/oracle/grid.rsp > /home/oracle/inst-grid.rsp
# remove blank lines and #
sed -e '/^$/d' -e '/^ $/d' -e '/^#/d' grid.rsp | perl -ne 'print unless /^$/' 

sed -e '/^$/d' -e '/^ $/d' -e '/^#/d' /home/oracle/db_install.rsp > /home/oracle/inst-db.rsp

cd /software/grid
nohup ./runInstaller -silent -force -responseFile /home/oracle/inst-grid.rsp > /home/oracle/inst-grid.log 2> /home/oracle/inst-grid.err &

cat /home/oracle/inst-grid.rsp
#
oracle.install.responseFileVersion=/oracle/install/rspfmt_crsinstall_response_schema_v11_2_0
ORACLE_HOSTNAME=melnaborcl
INVENTORY_LOCATION=/u01/app/oraInventory
SELECTED_LANGUAGES=en
oracle.install.option=HA_CONFIG
ORACLE_BASE=/u01/app/oracle
ORACLE_HOME=/u01/app/oracle/11.2.0/grid
oracle.install.asm.OSDBA=asmdba
oracle.install.asm.OSOPER=asmoper
oracle.install.asm.OSASM=asmadmin
oracle.install.crs.config.gpnp.scanName=melnabo-cluster
oracle.install.crs.config.gpnp.scanPort=1521
oracle.install.crs.config.clusterName=melnabo-cluster
oracle.install.crs.config.gpnp.configureGNS=false
oracle.install.crs.config.gpnp.gnsSubDomain=
oracle.install.crs.config.gpnp.gnsVIPAddress=
oracle.install.crs.config.autoConfigureClusterNodeVIP=false
oracle.install.crs.config.clusterNodes=melnaborcl:melnaborcl-vip
oracle.install.crs.config.networkInterfaceList=eth0:10.65.5.0:1
oracle.install.crs.config.storageOption=
oracle.install.crs.config.sharedFileSystemStorage.diskDriveMapping=
oracle.install.crs.config.sharedFileSystemStorage.votingDiskLocations=
oracle.install.crs.config.sharedFileSystemStorage.votingDiskRedundancy=NORMAL
oracle.install.crs.config.sharedFileSystemStorage.ocrLocations=
oracle.install.crs.config.sharedFileSystemStorage.ocrRedundancy=NORMAL
               	
oracle.install.crs.config.useIPMI=false
oracle.install.crs.config.ipmi.bmcUsername=
oracle.install.crs.config.ipmi.bmcPassword=
oracle.install.asm.SYSASMPassword=Passw0rd
oracle.install.asm.diskGroup.name=DATA
oracle.install.asm.diskGroup.redundancy=EXTERNAL
oracle.install.asm.diskGroup.AUSize=1
oracle.install.asm.diskGroup.disks=ORCL:DATA1,ORCL:DATA2
oracle.install.asm.diskGroup.diskDiscoveryString=
oracle.install.asm.monitorPassword=Passw0rd
oracle.install.crs.upgrade.clusterNodes=
oracle.install.asm.upgradeASM=false
oracle.installer.autoupdates.option=SKIP_UPDATES
oracle.installer.autoupdates.downloadUpdatesLoc=
AUTOUPDATES_MYORACLESUPPORT_USERNAME=
AUTOUPDATES_MYORACLESUPPORT_PASSWORD=
PROXY_HOST=
PROXY_PORT=0
PROXY_USER=
PROXY_PWD=
PROXY_REALM=


# On the server, run as root:
/u01/app/oraInventory/orainstRoot.sh
/u01/app/oracle/11.2.0/grid/root.sh

# Run asmca from GUI to create the ASM diskgroup and starts the ASM instance
asmca

# List the install the response file for the DB installer
oracle.install.responseFileVersion=/oracle/install/rspfmt_dbinstall_response_schema_v11_2_0
oracle.install.option=INSTALL_DB_SWONLY
ORACLE_HOSTNAME=melnaborcl
UNIX_GROUP_NAME=oinstall
INVENTORY_LOCATION=/u01/app/oraInventory
SELECTED_LANGUAGES=en
ORACLE_HOME=/u01/app/oracle/11.2.0/dbhome_1
ORACLE_BASE=/u01/app/oracle
oracle.install.db.InstallEdition=EE
oracle.install.db.EEOptionsSelection=false
oracle.install.db.optionalComponents=
oracle.install.db.DBA_GROUP=dba
oracle.install.db.OPER_GROUP=oper
oracle.install.db.CLUSTER_NODES=
oracle.install.db.isRACOneInstall=false
oracle.install.db.racOneServiceName=
oracle.install.db.config.starterdb.type=GENERAL_PURPOSE
oracle.install.db.config.starterdb.globalDBName=
oracle.install.db.config.starterdb.SID=
oracle.install.db.config.starterdb.characterSet=
oracle.install.db.config.starterdb.memoryOption=false
oracle.install.db.config.starterdb.memoryLimit=
oracle.install.db.config.starterdb.installExampleSchemas=false
oracle.install.db.config.starterdb.enableSecuritySettings=true
oracle.install.db.config.starterdb.password.ALL=
oracle.install.db.config.starterdb.password.SYS=
oracle.install.db.config.starterdb.password.SYSTEM=
oracle.install.db.config.starterdb.password.SYSMAN=
oracle.install.db.config.starterdb.password.DBSNMP=
oracle.install.db.config.starterdb.control=DB_CONTROL
oracle.install.db.config.starterdb.gridcontrol.gridControlServiceURL=
oracle.install.db.config.starterdb.automatedBackup.enable=false
oracle.install.db.config.starterdb.automatedBackup.osuid=
oracle.install.db.config.starterdb.automatedBackup.ospwd=
oracle.install.db.config.starterdb.storageType=
oracle.install.db.config.starterdb.fileSystemStorage.dataLocation=
oracle.install.db.config.starterdb.fileSystemStorage.recoveryLocation=
oracle.install.db.config.asm.diskGroup=
oracle.install.db.config.asm.ASMSNMPPassword=
MYORACLESUPPORT_USERNAME=
MYORACLESUPPORT_PASSWORD=
SECURITY_UPDATES_VIA_MYORACLESUPPORT=false
DECLINE_SECURITY_UPDATES=true
PROXY_HOST=
PROXY_PORT=
PROXY_USER=
PROXY_PWD=
PROXY_REALM=
COLLECTOR_SUPPORTHUB_URL=
oracle.installer.autoupdates.option=SKIP_UPDATES
oracle.installer.autoupdates.downloadUpdatesLoc=
AUTOUPDATES_MYORACLESUPPORT_USERNAME=
AUTOUPDATES_MYORACLESUPPORT_PASSWORD=

# change the ORACLE_HOME to point from grid to the database directory
cd /software/database
nohup ./runInstaller -silent -force -responseFile /home/oracle/inst-db.rsp > /home/oracle/inst-db.log 2> /home/oracle/inst-db.err &

# Login as root and run the following:
/u01/app/oracle/11.2.0/dbhome_1/root.sh

```
