#!/bin/sh

# This is a shell-based Vagrant provisioning script to update Puppet to latest
# on CentOS systems using PuppetLabs' yum repository.
#
# Copyright 2014 Square, Inc.
set -e
set -x

majorver=`rpm -q centos-release|cut -d '-' -f 3`

# Install EPEL repos
case $majorver in
    5)
        echo "Stop building shit in CentOS 5!"
        exit 1
        ;;
    6)
        rpm -q epel-release || sudo rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
        ;;
    7)
        rpm -q epel-release || sudo rpm -Uvh http://dl.fedoraproject.org/pub/epel/beta/7/x86_64/epel-release-7-0.2.noarch.rpm
        ;;
esac

# Install latest Puppet
rpm -q puppetlabs-release || \
    sudo rpm -Uvh http://yum.puppetlabs.com/puppetlabs-release-el-${majorver}.noarch.rpm
rpm -q puppet || sudo yum -y -d0 -e0 -q install puppet
sudo yum -y -d0 -e0 -q update puppet
