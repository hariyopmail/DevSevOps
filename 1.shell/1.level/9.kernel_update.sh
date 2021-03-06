#!/bin/bash
#Author : https://github.com/owen7005
# Date : 2016-07-01 13:50
# import key
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org

# install elrepo repo
rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm

# install kernel
yum --enablerepo=elrepo-kernel install kernel-lt kernel-lt-headers kernel-lt-devel -y

# modify grub
grub2-set-default 0
