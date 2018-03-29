Overview
========

How to add disks to Linux: 

1. To list the LUN ID and sd devices 
```
ls -ld /sys/block/sd*/device
```

2. Before you start identify all sd devices with this command:
```
ls /dev/sd*
smartctl --scan
``` 
 
3. Determine which host ports are in use:
```
# grep mpt /sys/class/scsi_host/host?/proc_name
/sys/class/scsi_host/host2/proc_name:mptspi 
/sys/class/scsi_host/host3/proc_name:mptspi 
```

4. Now rescan those ports (in this example host2 and host3): 
```
echo "- - -" > /sys/class/scsi_host/host2/scan 
echo "- - -" > /sys/class/scsi_host/host3/scan 
```

5. Now look for a new device with this command:
```
smartctl --scan
```
 
6. smartctl -a /dev/sde 

```
ls /sys/class/scsi_host/host?/proc_name 
for i in `ls ‐1 /sys/class/scsi_host`; do 
echo "‐ ‐ ‐" > /sys/class/scsi_host/${i}/scan 
done 

echo '1' > /sys/class/scsi_disk/0\:0\:0\:0/device/rescan 
```
7. Automating disk partitioning

```
(
echo o # Create a new empty DOS partition table
echo n # Add a new partition
echo p # Primary partition
echo 1 # Partition number
echo   # First sector (Accept default: 1)
echo   # Last sector (Accept default: varies)
echo w # Write changes
) | sudo fdisk

echo -e "o\nn\np\n1\n\n\nw" | fdisk /dev/sda


dev='/dev/sdb'
sudo umount "$dev"
printf "o\nn\np\n1\n\n\nw\n" | sudo fdisk "$dev"
sudo mkfs.ext4 "${dev


fdisk -u -p /dev/whatever <<EOF
n
p
1

w
EOF
```

To add a SCSI device in the host, we will need to rescan the SCSI bus:
```
echo "- - -" > /sys/class/scsi_host/host<h>/scan
```

You can also do this if you know the device SCSI location h:c:t:l
```
echo "c t l" >  /sys/class/scsi_host/host<h>/scan
```

Replace $HOST with the SCSI host you want to scan which could be host0, host1, host2, etc. Typically $HOST is host0.
```
echo "- - -" > /sys/class/scsi_host/$HOST/scan
```

To add a new disk, we will need to find the host bus number:
```
grep mpt /sys/class/scsi_host/host?/proc_name
```

You should be able to see the host bus number in the result of the grep command. Rescan the the bus by running (assuming the bus # is 2):
```
echo "- - -" > /sys/class/scsi_host/host2/scan
```

Use lsscsi to list the new block devices:
```
lsscsi
```

The “- - -“ defines the three values stored inside host*/scan i.e. channel number, SCSI target ID, and LUN values. We are simply replacing the values with wild cards so that it can detect new changes attached to the Linux box. This procedure will add LUNs, but not remove them.

After you expand an existing disk, issue either of the following command to force the rereading of the disk geometry:

```
ls /sys/class/scsi_device/1\:0\:0\:0/device/
ls /sys/block/sda/device/rescan 
echo 1 > /sys/class/scsi_device/1\:0\:0\:0/device/rescan
echo 1 > /sys/block/sda/device/rescan
```

Replace $DEVICE with sda, sdb, sdc, etc.
```
echo 1 > /sys/block/$DEVICE/device/rescan
```

```
### To scan the newly added Disk
for h in $ (ls -1 / sys / class / scsi_host); 
echo "- - -"> / sys / class / scsi_host / $ h / scan; 
done

ls /sys/class/scsi_host/host?/proc_name | awk -F"/proc_name" '{ print $1"/scan" }' | while read adapter; do
echo '- - -' > $adapter
done
```

To remove a SCSI device from the system:
```
echo 1 > /sys/class/scsi_device/h:c:t:l/device/delete    , or
echo 1 > /sys/block/<dev>/device/delete
```

where <dev> is like sda or sdb etc.
h == hostadapter id (first one being 0)
c == SCSI channel on hostadapter (first one being 0)
t == ID
l == LUN (first one being 0)
