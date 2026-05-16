#!/bin/bash
set -e
echo "=== Provisioning Client: $(hostname) ==="
sudo yum install -y bind-utils
sudo tee /etc/resolv.conf << 'RESEOF'
search domain.com
nameserver 192.168.10.1
RESEOF
echo "=== Client provisioning complete! ==="
