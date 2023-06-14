ARCH := $(shell uname -m)
IP := $(shell ip -f inet -o a | grep "2:" | sed -E -e "s/(\s+)/ /g" | cut -d " " -f 4 | cut -d "/" -f 1)

# Default target
# all: ipxe #install uefi os ignition

# Build the IPXE bootloader with embeded script for arm64 efi
.PHONY: ipxe
ipxe:
ifeq ($(ARCH), aarch64)
	cd ipxe/src && $(MAKE) EMBED=../../boot.ipxe bin-arm64-efi/snponly.efi
else
	cd ipxe/src && $(MAKE) EMBED=../../boot.ipxe CROSS=aarch64-linux-gnu bin-arm64-efi/snponly.efi
endif

# Create the ignition files required for coreos configuration
ignition:
	podman run --rm --interactive --security-opt label=disable --volume "${PWD}":/pwd --workdir /pwd quay.io/coreos/butane:release ./config.bu > ./config.ign

install:
	mkdir -p /srv/www/boot
	mkdir -p /srv/tftp
	sed -E -i -e "s/^(dhcp-range).*$$/dhcp-range=$(IP),proxy/" dnsmasq.conf 
	chown -R www-data:www-data /srv/www/
	chown -R dnsmasq:dnsmasq /srv/tftp/

# Pull the most recent version of coreos; or do nothing if it already exists
#make os

# Build the PI UEFI; based on EDK2 RPI UEFI image; 3GB+ support enabled
# This should probably be its own repo
#make uefi