#!/bin/bash
set -e

if [ -z $DHCP_SERVER_IP ]; then
  echo "DHCP Server IP is not set in the environment!"
  exit 1
fi

cat > /etc/dnsmasq.conf <<EOF
  interface=eth0
  port=0
  dhcp-range=$DHCP_SERVER_IP,proxy
  enable-tftp
  tftp-root=/srv/tftp
  tftp-secure
  # iPXE uses option 175
  dhcp-match=set:ipxe,175
  # Boot tag for raspberry pi initial boot
  pxe-service=0,"Raspberry Pi Boot"
  # Boot tag for UEFI PXE boot, excluding iPXE because it would continually try to boot ipxe
  pxe-service=tag:!ipxe,ARM64_EFI,"iPXE Boot",snponly.efi
  pxe-service=tag:!ipxe,x86-64_EFI,"iPXE Boot",ipxe.efi
EOF

exec "$@"
