#!/bin/bash


if [ "$1" = "-install" ];then
   path=`pwd`
   cd /etc/yum.repos.d
   wget http://download.openvz.org/openvz.repo
   rpm --import http://download.openvz.org/RPM-GPG-Key-OpenVZ
   yum install vzkernel vzctl vzquota ploop -y
   cd $path
else if [ "$1" = "-c" ] && [ -n "$2" ];then
       vzctl create $2 --ostemplate centos-6-x86_64 --config basic
       vzctl set $2 --onboot yes --save
       echo "please input hostname:"
       read hostname
       if [ -z "$hostname" ];then
          vzctl set $2 --hostname $hostname --save
          echo "hostname: $hostname"
       fi
       echo "please input ipadd:"
       read ipadd
       if [ ! -z "$ipadd" ];then
          vzctl set $2 --ipadd $ipadd --save
          echo "ipaddr: $ipadd"
       else
          echo "error"
          exit
       fi
       
       vzctl set $2 --numothersock 120 --save
       vzctl set $2 --nameserver 202.98.192.67 --nameserver 210.40.0.33 --save
       vzctl start $2
       echo "please input $2 passwd"
       vzctl exec $2 passwd       

     else
       echo "parameters error" 
       exit
     fi 
fi

#net.ipv4.ip_forward = 1
#net.ipv4.conf.default.proxy_arp = 0
#net.ipv4.conf.all.rp_filter = 1
#kernel.sysrq = 1
#net.ipv4.conf.default.send_redirects = 1
#net.ipv4.conf.all.send_redirects = 0
#net.ipv4.icmp_echo_ignore_broadcasts=1
#net.ipv4.conf.default.forwarding=1
