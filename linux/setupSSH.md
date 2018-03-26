## Overview

## Setup

```
# On the client and server machine if ssh is not installed yet !!
yum -y install openssh-clients

# On the client machine:
#
# creates two sets of keys - private (~/.ssh/id_rsa) and public (~/.ssh/id_rsa.pub) 
ssh-keygen -t rsa -f /root/.ssh/id_rsa

# ssh-copy-id is a script that populates the id_rsa.pub to the remote server (server02)
ssh-copy-id -i ~/.ssh/id_rsa.pub root@server02

# If you are running from the client machine, you will can run the following:
ssh root@server02 'mkdir -p /root/.ssh'

# scp /root/.ssh/id_rsa.pub root@server02:/root/.ssh/authorized_keys
# /root/.ssh/id_rsa.pub is the source
cat /root/.ssh/id_rsa.pub | ssh root@server02 'cat >> .ssh/authorized_keys'

ssh root@server02 'chmod 700 /root/.ssh'
ssh root@server02 'chmod 600 /root/.ssh/*'

#
# On the server machine:
# list of public keys authorised to access the server
# copy the public key to the server and append it to .ssh/authorized_keys
#

chmod 0700 ~/.ssh
chmod 600 ~/.ssh/id_rsa
chmod 644 ~/.ssh/id_rsa.pub  
chmod 0644 ~/.ssh/authorized_keys

# Edit SSH Server Configuration File (/etc/ssh/sshd_config)
# vi /etc/ssh/sshd_config 
# To disable root logins, edit or add as follows: 
PermitRootLogin no 
# Uncomment the following to enable root login:
# PermitRootLogin yes
Restrict login to user tom and jerry only over ssh: 
AllowUsers tom jerry 
Change ssh port i.e. run it on a non-standard port like 1235 
Port 1235 
# To limit SSH server to listen on specific address, replace 0.0.0.0 with the IP address
#ListenAddress 0.0.0.0
 
Save and close the file. Restart sshd: 
# service sshd restart

# To test connecting from the client machine:
#

chmod 600 ~/.ssh/known_hosts
# To reset the server02 (10.10.10.1) from the known host key
sed -i /10.10.10.1/d /root/.ssh/known_hosts

ssh -i ~/.ssh/id_rsa root@server02
ssh -l root server02

chmod 0755 ~/.ssh/config

# cat ~/.ssh/config 
Host server02 
Hostname 10.10.10.1 
User root
Port 22 
IdentityFile ~/.ssh/id_rsa 
# ssh server02

```
