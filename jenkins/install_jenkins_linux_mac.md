Installing Jenkins on Linux/Mac
===============================

The following are steps required in setting up Jenkins on

Ubuntu
------
Follow the steps below to install Jenkins on Ubuntu:

1) Update the Ubuntu operating system with the latest releases:
```
apt-get update
```

2) Jenkins require a web server on the host. We are using nginx on the host. To install:
```
apt-get install nginx , or apt -y install nginx
```

3) Check the status of the nginx web services
```
service nginx status
```

4) Launch a web browser and point to the IP address of this host. You should get a message Welcome to nginx!

5) Another package required for Jenkins install is Java. Install it by running:
```
apt-get install openjdk-7-jdk
```

6) To verify if Java is successfully installed, check the version of Java installed:
```
java -version
```

7) Now we are ready to install Jenkins, add the key to apt:
```
wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add –
```

8) Next, we will need to add a source list for Jenkins to apt:
```
sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
```

9) Update the apt’s cache before installing Jenkins:
```
apt-get update
```

10) Install Jenkins on the host:
```
apt-get install jenkins
```

11) Ensure Jenkins is running:
```
service jenkins status
```

12) If you need to restart Jenkins, enter:
```
service jenkins restart
```

CentOS
------



MacOS
-----


Additional Information
----------------------
When we installed Jenkins, it run it as a daemon service upon startup. For more details, check out the content /etc/init.d/jenkins. The 'jenkins' user is created on the host to run this service. All log files will be placed in /var/log/jenkins/jenkins.log. Check this file if you need to troubleshoot Jenkins. All configuration parameters for the launch such as JENKINS_HOME is stored in /etc/default/jenkins. By default, Jenkins listen on port 8080. Access this port with your browser to start the configuration on the host - http://IP-address:8080 . If port 8080 is already in use, edit the /etc/default/jenkins to switch to a different port (8080 to 8088) by relacing the following line:
```
HTTP_PORT=8080
```
by
```
HTTP_PORT=8088
```
