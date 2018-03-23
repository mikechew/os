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
mkdir /home/git/hub/my-project
touch /home/git/hub/my-project/README
git init --bare /hub/my-project.git

# Configure some default git options. These could be set globally in the /etc/git/gitconfig file or ~/.gitconfig
su - git

# From the git user:
sudo git config –global user.name “John Doe”
sudo git config –global user.email johndoe@example.com

# From the root user
git config --list

```

On the client running GIT client software:
```
git clone git@10.65.5.202:/hub/my-project.git
```
