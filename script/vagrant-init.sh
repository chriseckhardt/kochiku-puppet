#!/bin/sh

# This is a shell-based Vagrant provisioning script to update Puppet to latest
# on CentOS systems using PuppetLabs' yum repository.
#
# Copyright 2014 Square, Inc.
set -e
set -x

majorver=`rpm -q centos-release|cut -d '-' -f 3`
rpm -q puppetlabs-release || \
  sudo rpm -Uvh http://yum.puppetlabs.com/puppetlabs-release-el-${majorver}.noarch.rpm
rpm -q puppet || sudo yum -y -d0 -e0 -q install puppet
sudo yum -y -d0 -e0 -q update puppet
