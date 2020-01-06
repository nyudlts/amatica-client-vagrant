#!/bin/bash

yum update -y

yum install -y epel-release

yum install java-1.8.0-openjdk-headless elasticsearch mariadb

bash -c 'cat << EOF > /etc/yum.repos.d/archivematica.repo
[archivematica]
name=archivematica
baseurl=https://packages.archivematica.org/1.10.x/centos
gpgcheck=1
gpgkey=https://packages.archivematica.org/1.10.x/key.asc
enabled=1
EOF'

bash -c 'cat << EOF > /etc/yum.repos.d/archivematica-extras.repo
[archivematica-extras]
name=archivematica-extras
baseurl=https://packages.archivematica.org/1.10.x/centos-extras
gpgcheck=1
gpgkey=https://packages.archivematica.org/1.10.x/key.asc
enabled=1
EOF'

yum install -y archivematica-common archivematica-dashboard archivematica-mcp-client

sudo ln -sf /usr/bin/7za /usr/bin/7z

sed -i 's/^#TCPSocket/TCPSocket/g' /etc/clamd.d/scan.conf

sed -i 's/^Example//g' /etc/clamd.d/scan.conf

systemctl enable fits-nailgun
systemctl start fits-nailgun
systemctl enable clamd@scan
systemctl start clamd@scan
systemctl enable archivematica-mcp-client
systemctl start archivematica-mcp-client

