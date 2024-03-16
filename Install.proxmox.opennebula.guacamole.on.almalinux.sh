#!/bin/bash

# Update package lists
sudo dnf update -y

# Install dependencies
sudo dnf install epel-release -y
sudo dnf install wget curl git bzip2 zlib unzip jq -y

# Install Proxmox VE
wget https://repo.proxmox.com/stable/el/8/proxmox-ve-release-8.x.x.el8.noarch.rpm
sudo dnf install ./proxmox-ve-release-8.x.x.el8.noarch.rpm -y
sudo dnf install proxmox-ve -y
rm ./proxmox-ve-release-8.x.x.el8.noarch.rpm

# Install OpenNebula
curl https://downloads.opennebula.org/releases/stable/opennebula.repo | sudo tee /etc/yum.repos.d/opennebula.repo
sudo dnf install opennebula-server opennebula-tools opennebula-libvirt -y

# Configure OpenNebula (basic - edit /etc/one/oned.conf for further configuration)
sudo onehost enable

# Install Apache Guacamole
sudo dnf -y install httpd php php-mysqlnd

# Download Guacamole source
cd /tmp
wget https://sourceforge.net/projects/guacamole/files/guacamole/1.4.0/guacamole-1.4.0.tar.gz
tar -xvf guacamole-1.4.0.tar.gz

# Compile and install Guacamole
cd guacamole-1.4.0
./configure --enable-mysql
make
sudo make install

# Configure Guacamole (extensive configuration needed in /etc/guacamole)
sudo cp /tmp/guacamole-1.4.0/ guacamole.conf /etc/guacamole/

# Enable and start services
sudo systemctl enable httpd
sudo systemctl enable one-scheduler
sudo systemctl enable onehost
sudo systemctl start httpd
sudo systemctl start one-scheduler
sudo systemctl start onehost

echo "Proxmox VE, OpenNebula, and Guacamole installation complete!"
echo "**Remember to configure OpenNebula and Guacamole further for your specific needs.**"
