ARCH := $(shell uname -m)
# Default target
make all: ipxe #install uefi os ignition

# Build the IPXE bootloader with embeded script for arm64 efi
.PHONY: ipxe
make ipxe:
ifeq ($(ARCH), aarch64)
	cd ipxe/src && $(MAKE) EMBED=../../boot.ipxe bin-arm64-efi/snponly.efi
else
	cd ipxe/src && $(MAKE) EMBED=../../boot.ipxe CROSS=aarch64-linux-gnu bin-arm64-efi/snponly.efi
endif

# Pull the most recent version of coreos; or do nothing if it already exists
#make os

# Create the ignition files required for coreos configuration
#make ignition:
#	podman run --rm --interactive --security-opt label=disable --volume "${PWD}":/pwd --workdir /pwd quay.io/coreos/butane:release ./config.bu > ./config.ign

# Build the PI UEFI; based on EDK2 RPI UEFI image; 3GB+ support enabled 
#make uefi

#make install