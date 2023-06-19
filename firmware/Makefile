ARCH := $(shell uname -m)

# Build the IPXE bootloader with embeded script for arm64 efi and x86_64 efi
.PHONY: ipxe
ipxe:
ifeq ($(ARCH), aarch64)
	cd ipxe/src && $(MAKE) EMBED=../../boot-arm64.ipxe bin-arm64-efi/snponly.efi
	cd ipxe/src && $(MAKE) EMBED=../../boot-x86_64.ipxe CROSS=x86_64-linux-gnu- bin-x86_64-efi/ipxe.efi
else ifeq ($(ARCH), x86_64)
	cd ipxe/src && $(MAKE) EMBED=../../boot-x86_64.ipxe bin-x86_64-efi/ipxe.efi
	cd ipxe/src && $(MAKE) EMBED=../../boot-arm64.ipxe CROSS=aarch64-linux-gnu- bin-arm64-efi/snponly.efi
endif

# Build the PI UEFI; based on EDK2 RPI UEFI image; 3GB+ support enabled
#uefi