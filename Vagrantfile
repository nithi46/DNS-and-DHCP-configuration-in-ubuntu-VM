 Vagrant.configure("2") do |config|

  # ── G1: DHCP Server (CentOS) ──────────────────────────
  config.vm.define "G1" do |g1|
    g1.vm.box = "generic/centos8"
    g1.vm.hostname = "G1"
    g1.vm.network "private_network", ip: "192.168.10.1",
      netmask: "255.255.255.0", name: "vboxnet0"

    g1.vm.provider "virtualbox" do |v|
      v.memory = 1024
      v.cpus = 1
    end

    g1.vm.provision "shell", inline: <<-SHELL
      yum install -y dhcp-server

      cat > /etc/dhcp/dhcpd.conf <<'EOF'
default-lease-time 600;
max-lease-time 7200;

subnet 192.168.10.0 netmask 255.255.255.0 {
  range 192.168.10.1 192.168.10.50;
  option routers 192.168.10.1;
  option domain-name-servers 8.8.8.8;
}
EOF

      systemctl enable dhcpd
      systemctl start dhcpd
      systemctl status dhcpd
    SHELL
  end

  # ── M1: Client 1 ──────────────────────────────────────
  config.vm.define "M1" do |m1|
    m1.vm.box = "generic/centos8"
    m1.vm.hostname = "M1"
    m1.vm.network "private_network", ip: "192.168.10.11", netmask: "255.255.255.0", name: "vboxnet0"

    m1.vm.provider "virtualbox" do |v|
      v.memory = 512
      v.cpus = 1
    end
  end

  # ── M2: Client 2 ──────────────────────────────────────
  config.vm.define "M2" do |m2|
    m2.vm.box = "generic/centos8"
    m2.vm.hostname = "M2"
    m2.vm.network "private_network", ip: "192.168.10.12", netmask: "255.255.255.0", name: "vboxnet0"

    m2.vm.provider "virtualbox" do |v|
      v.memory = 512
      v.cpus = 1
    end
  end

end
