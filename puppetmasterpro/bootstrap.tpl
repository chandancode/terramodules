#!/bin/bash
/bin/echo "HOSTNAME=mypuppetserver" > /etc/hostname
/bin/echo "HOSTNAME=mypuppetserver" >> /etc/sysconfig/network
/bin/echo "preserve_hostname: true" >> /etc/cloud/cloud.cfg
/bin/yum makecache fast
/bin/yum install wget -y
sleep 30
/bin/rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-6.noarch.rpm
/bin/yum -y install puppetserver
cat >/etc/puppetlabs/puppet/puppet.conf << EOL
[main]
certname=mypuppetserver

[agent]
server=mypuppetserver
report=true
EOL
service puppetserver start
