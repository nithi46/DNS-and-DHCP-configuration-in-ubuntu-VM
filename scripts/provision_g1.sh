#!/bin/bash
set -e
echo "=== Provisioning G1: DNS + DHCP Server ==="
sudo yum install -y bind bind-utils dhcp-server

# named.conf
sudo cp /vagrant/dns/named.conf /etc/named.conf

# Zone files
sudo cp /vagrant/dns/forward.domain.com.db /var/named/
sudo cp /vagrant/dns/reverse.domain.com.db /var/named/
sudo chown named:named /var/named/forward.domain.com.db
sudo chown named:named /var/named/reverse.domain.com.db
sudo chmod 640 /var/named/forward.domain.com.db
sudo chmod 640 /var/named/reverse.domain.com.db

# DHCP
sudo cp /vagrant/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf

sudo systemctl enable --now named
sudo systemctl enable --now dhcpd
echo "=== G1 provisioning complete! ==="
