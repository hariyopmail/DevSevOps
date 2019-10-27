#!/bin/bash
#���ű�������rhel5�汾ϵͳ
#NIC name: eth0
#MAC address:00:50:56:a6:3c:33
#Bridge name: br0
#Addressing mode:DHCP
#����ǽ�Ƿ�������



if [ -f /etc/sysconfig/network-scripts/ifcfg-eth0 ]; then 
  flag1=true; 
else echo 'File /etc/sysconfig/network-scripts/ifcfg-eth0 does not exist!' 
fi 
if [ -f /etc/sysctl.conf ]; then 
  flag2=true; 
else echo 'File /etc/sysctl.conf does not exist!' 
fi 
if [ -f /etc/sysconfig/iptables ]; then 
  flag3=true; 
else echo 'File /etc/sysconfig/iptables does not exist!' 
fi 
ethtool eth0 | grep -i 'link detected: yes' > null 
if [ $? -ne 0 ]; then 
  echo 'NIC eth0 not found!'; 
else flag4=true; 
fi 
if [ $flag1 ] && [ $flag2 ] && [ $flag3 ] && [ $flag4 ]; then 

  ifdown eth0

  # configure ifcfg-eth0
  if [ -f /etc/sysconfig/network-scripts/ifcfg-eth0 ]; then 
    backupTime=`date '+%Y-%m-%d-%H:%M:%S'`
    echo 'Backup original /etc/sysconfig/network-scripts/ifcfg-eth0 to /etc/sysconfig/network-scripts/bak-ifcfg-eth0-'$backupTime
    cp /etc/sysconfig/network-scripts/ifcfg-eth0 /etc/sysconfig/network-scripts/bak-ifcfg-eth0-$backupTime
  fi
  cat > /etc/sysconfig/network-scripts/ifcfg-eth0 << EOF
DEVICE=eth0
HWADDR=`cat /sys/class/net/eth0/address`
TYPE=Ethernet
BOOTPROTO=none
ONBOOT=yes
BRIDGE=br0
NM_CONTROLLED=no
EOF

  # configure ifcfg-br0
  if [ -f /etc/sysconfig/network-scripts/ifcfg-br0 ]; then 
    backupTime=`date '+%Y-%m-%d-%H:%M:%S'`
    echo 'Backup original /etc/sysconfig/network-scripts/ifcfg-br0 to /etc/sysconfig/network-scripts/bak-ifcfg-br0-'$backupTime
    cp /etc/sysconfig/network-scripts/ifcfg-br0 /etc/sysconfig/network-scripts/bak-ifcfg-br0-$backupTime
  else 
    touch /etc/sysconfig/network-scripts/ifcfg-br0
  fi
  cat > /etc/sysconfig/network-scripts/ifcfg-br0 << EOF
DEVICE=br0
TYPE=Bridge
BOOTPROTO=dhcp
ONBOOT=yes
DELAY=0
NM_CONTROLLED=no
EOF

  echo 'Start eth0 and br0.'
  ifup eth0
  ifup br0

  # configure sysctl.conf
  grep -i 'net.ipv4.ip_forward = 1' /etc/sysctl.conf > null
  if [ $? -ne 0 ]; then
    backupTime=`date '+%Y-%m-%d-%H:%M:%S'`
    echo 'Backup original /etc/sysctl.conf to /etc/bak-sysctl.conf-'$backupTime
    cd /etc/
    sed -i'bak-*-'$backupTime '$a#Bridged network configuration\nnet.ipv4.ip_forward = 1' sysctl.conf
  fi
  grep -i 'net.bridge.bridge-nf-call' /etc/sysctl.conf > null
  if [ $? -ne 0 ]; then
    backupTime=`date '+%Y-%m-%d-%H:%M:%S'`
    echo 'Backup original /etc/sysctl.conf to /etc/bak-sysctl.conf-'$backupTime
    cd /etc/
    sed -i'bak-*-'$backupTime '$a#Bridged network configuration\nnet.bridge.bridge-nf-call-ip6tables = 0\nnet.bridge.bridge-nf-call-iptables = 0\nnet.bridge.bridge-nf-call-arptables = 0' sysctl.conf
  fi

  echo 'Apply the configurations of /etc/sysctl.conf.'
  sysctl -p /etc/sysctl.conf

  # configure iptables
  grep -i 'br0' /etc/sysconfig/iptables > null
  if [ $? -ne 0 ]; then
    backupTime=`date '+%Y-%m-%d-%H:%M:%S'`
    echo 'Backup original /etc/sysconfig/iptables to /etc/sysconfig/bak-iptables-'$backupTime
    cd /etc/sysconfig/
    sed -i'bak-*-'$backupTime '/COMMIT/i -A RH-Firewall-1-INPUT -i br0 -j ACCEPT' iptables
  fi

  echo 'Restart the firewall.'
  service iptables restart

  echo 'Reload the libvirt daemon.'
  service libvirtd reload
  echo 'Check the bridges.'
  brctl show

fi 
