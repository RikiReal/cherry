FROM ubuntu:latest as build
WORKDIR /src
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    zip
RUN curl -sSL -o ipxe.zip https://github.com/ipxe/ipxe/archive/refs/heads/master.zip && unzip -q ipxe.zip
RUN mv ipxe-master ipxe
COPY . .
RUN make -j 4 NO_WERROR=1 ipxe


# FROM ubuntu:latest as setup
# RUN apt-get update && apt-get install -y \
#     dnsmasq
# RUN mkdir -p /srv/tftp
# COPY --from=build 
#     /src/ipxe/src/bin-arm64-efi/snponly.efi \
#     /src/ipxe/src/bin-x86_64-efi/ipxe.efi \
#     /src/dnsmasq.conf \
#     /srv/tftp


# Read up on how Dockerfiles actually work

# Install dnsmasq
# Configure dnsmasq
# Build ipxe
### Build uefi
# Start dnsmasq and serve pi firmware, uefi and ipxe



# Using docker I can build two version of ipxe, one x86 and one arm64
# and host both of them over tftp