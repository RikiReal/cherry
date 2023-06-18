FROM ubuntu:jammy as build-ipxe
ARG TARGETARCH
ARG CC=gcc-aarch64-linux-gnu
RUN case $TARGETARCH in \
        "amd64") CC=gcc-aarch64-linux-gnu ;; \
        "arm64") CC=gcc-x86-64-linux-gnu ;; \
    esac 
WORKDIR /src
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    $CC \
    && rm -rf /var/lib/apt/lists/*
ENV IPXE_VERSION=1.21.1
RUN curl -sSL -o ipxe.tar.gz https://github.com/ipxe/ipxe/archive/refs/tags/v$IPXE_VERSION.tar.gz \
    && tar -xzf ipxe.tar.gz \
    && mv ipxe-$IPXE_VERSION ipxe
COPY boot-* Makefile .
RUN make -j 4 NO_WERROR=1 ipxe

FROM ubuntu:jammy as run
RUN apt-get update && apt-get install -y \
    dnsmasq \
    && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /srv/tftp
COPY --from=build-ipxe \
    /src/ipxe/src/bin-arm64-efi/snponly.efi \
    /src/ipxe/src/bin-x86_64-efi/ipxe.efi \
    /srv/tftp
COPY pi-uefi/ /srv/tftp
COPY dnsmasq.conf.sh /
RUN chown -R dnsmasq:nogroup /srv/tftp \
    && chmod +x /dnsmasq.conf.sh

# DHCP and TFTP
EXPOSE 67/udp 69/udp
HEALTHCHECK CMD pidof -q dnsmasq
ENTRYPOINT ["/dnsmasq.conf.sh"]
CMD ["dnsmasq", "--keep-in-foreground", "--user=dnsmasq"]
