## Introduction

The following lists the instructions on how to setup GIT server on a Linux host.

On the GIT server:

```
cat install-git.sh

# Install the Git software
yum -y install git
# List the installed version
git --version

# Create a git user
groupadd git
useradd -m -s /bin/bash -g git git
passwd git

chmod 2770 /home/git/

mkdir -p /home/git/hub
ln -s /home/git/hub /hub
mkdir /hub/my-project
git init --bare /hub/my-project.git
chown -R git:git /hub/my-project

# Configure some default git options. These could be set globally in the /etc/git/gitconfig file or ~/.gitconfig
su - git

# From the git user:
git config --global user.name "John Doe"
git config --global user.email johndoe@example.com

# $ cat .gitconfig 
# [user]
# 	name = John Doe
# 	email = johndoe@example.com
  
# From the root user
git config --list

```

On the client running GIT client software:
```
yum -y install git
git clone git@10.65.5.202:/hub/my-project.git
cd my-project
touch README.txt
git add README.txt 
git commit
git push git@10.65.5.202:/hub/my-project.git master
cd ..
rm -fr my-project/
git clone git@10.65.5.202:/hub/my-project.git
 ll /tmp/my-project/
```

### Push source code from remote to the server
On the Git remote server:
```
git init --bare /home/git/hub/c-code.git
```

On the local server:
```
mkdir c-code
git init
vi hello.c
git add .
git commit -m 'initial commit'
git remote add origin ssh://git@10.65.5.202:22/home/git/hub/c-code.git
git push origin master
git remote -v
```
