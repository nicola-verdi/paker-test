#!/bin/bash
### extend root filesystem to occupy all the space 

/sbin/pvdisplay /dev/sdb
if [ $? -ne 0 ]
then
  /sbin/pvcreate /dev/sdb
  /sbin/vgextend vg_root /dev/sdb
  /sbin/lvextend -l +100%FREE /dev/vg_root/rootfs
  /sbin/resize2fs /dev/vg_root/rootfs
fi
