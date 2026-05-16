# DNS + DHCP Lab (Vagrant + VirtualBox)

A fully automated lab environment that provisions a **DNS server (BIND9)** and **DHCP server** on CentOS 9 using Vagrant and VirtualBox.

---

## Network Topology

```
┌─────────────────────────────────────────────┐
│           Private Network: 192.168.10.0/24  │
│                                             │
│   ┌──────────────┐     ┌────────────────┐   │
│   │     G1       │     │      M1        │   │
│   │ DNS + DHCP   │────▶│    Client 1    │   │
│   │ 192.168.10.1 │     │ 192.168.10.11  │   │
│   └──────┬───────┘     └────────────────┘   │
│          │                                  │
│          │             ┌────────────────┐   │
│          └────────────▶│      M2        │   │
│                        │    Client 2    │   │
│                        │ 192.168.10.12  │   │
│                        └────────────────┘   │
└─────────────────────────────────────────────┘
```

| VM | Role | IP | OS |
|----|------|----|----|
| G1 | DNS + DHCP Server | 192.168.10.1 | CentOS Stream 9 |
| M1 | Client | 192.168.10.11 | CentOS Stream 9 |
| M2 | Client | 192.168.10.12 | CentOS Stream 9 |

---

## Prerequisites

- [Vagrant](https://www.vagrantup.com/downloads) ≥ 2.3
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads) ≥ 6.1

---

## Quick Start

```bash
# Clone the repo
git clone https://github.com/<your-username>/dns-dhcp-lab.git
cd dns-dhcp-lab

# Start all VMs (auto-provisions DNS + DHCP)
vagrant up

# SSH into any machine
vagrant ssh G1
vagrant ssh M1
vagrant ssh M2
```

---

## Project Structure

```
dns-dhcp-lab/
├── Vagrantfile                     # VM definitions
├── README.md
├── scripts/
│   ├── provision_g1.sh             # Installs + configures DNS & DHCP on G1
│   └── provision_client.sh         # Configures DNS on M1/M2
├── dns/
│   ├── named.conf                  # BIND9 main config
│   ├── forward.domain.com.db       # Forward lookup zone
│   └── reverse.domain.com.db       # Reverse lookup zone
└── dhcp/
    └── dhcpd.conf                  # DHCP server config
```

---

## DNS Configuration

- **Domain:** `domain.com`
- **Zone files:** `/var/named/`
- **Service:** `named`

### Forward Lookup Zone

| Hostname | IP |
|----------|----|
| ns1.domain.com | 192.168.10.1 |
| g1.domain.com | 192.168.10.1 |
| m1.domain.com | 192.168.10.11 |
| m2.domain.com | 192.168.10.12 |
| www.domain.com | 192.168.10.1 |

### Reverse Lookup Zone

| IP | Hostname |
|----|----------|
| 192.168.10.1 | g1.domain.com |
| 192.168.10.11 | m1.domain.com |
| 192.168.10.12 | m2.domain.com |

---

## DHCP Configuration

- **Subnet:** `192.168.10.0/24`
- **Dynamic range:** `192.168.10.100 – 192.168.10.200`
- **Gateway:** `192.168.10.1`
- **DNS Server:** `192.168.10.1`
- **Service:** `dhcpd`

---

## Testing

### Test DNS (from M1 or M2)

```bash
vagrant ssh M1

# Forward lookup
nslookup m1.domain.com 192.168.10.1
nslookup m2.domain.com 192.168.10.1
nslookup www.domain.com 192.168.10.1

# Reverse lookup
nslookup 192.168.10.11 192.168.10.1
nslookup 192.168.10.12 192.168.10.1

# Using dig
dig @192.168.10.1 m1.domain.com
```

### Test DHCP (on G1)

```bash
vagrant ssh G1

# Check active leases
cat /var/lib/dhcpd/dhcpd.leases

# Check service status
sudo systemctl status dhcpd
sudo systemctl status named
```

---

## Troubleshooting

**Check BIND logs:**
```bash
sudo journalctl -u named | tail -30
sudo named-checkconf
sudo named-checkzone domain.com /var/named/forward.domain.com.db
```

**Check DHCP logs:**
```bash
sudo journalctl -u dhcpd | tail -30
```

**Restart services:**
```bash
sudo systemctl restart named
sudo systemctl restart dhcpd
```

---

## License

MIT
