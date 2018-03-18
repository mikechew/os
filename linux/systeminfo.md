Overview
========


cat /etc/hosts 

cat /etc/centos-release

To display the installed RedHat version/update:
```
cat /etc/redhat-release
```

To retrieve the release version on your system:
```
cat /etc/system-release
```

List of number of processors:
```
cat /proc/cpuinfo | grep core
cat /proc/cpuinfo | grep processor | wc -l 
```

List the total amount of memory:
```
grep MemTotal /proc/meminfo
cat /proc/meminfo | grep -i memtotal 
```

Used and free memory (-m for MB):
```
free -m
```

Check Swap Space. We have 3072 MB of swap size:
```
grep SwapTotal /proc/meminfo
```
