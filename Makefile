ARCH := $(shell uname -m)
IP := $(shell ip -f inet -o a | grep "2:" | sed -E -e "s/(\s+)/ /g" | cut -d " " -f 4 | cut -d "/" -f 1)

# Default target
# all: ipxe #install uefi

# Build the IPXE bootloader with embeded script for arm64 efi
.PHONY: ipxe
ipxe:
ifeq ($(ARCH), aarch64)
	cd ipxe/src && $(MAKE) EMBED=../../boot.ipxe bin-arm64-efi/snponly.efi
else
	cd ipxe/src && $(MAKE) EMBED=../../boot.ipxe CROSS=aarch64-linux-gnu bin-arm64-efi/snponly.efi
endif

install:
	mkdir -p /srv/tftp
	sed -E -i -e "s/^(dhcp-range).*$$/dhcp-range=$(IP),proxy/" dnsmasq.conf 
	chown -R dnsmasq:dnsmasq /srv/tftp/

# Build the PI UEFI; based on EDK2 RPI UEFI image; 3GB+ support enabled
#make uefi