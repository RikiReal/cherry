# Create the ignition files required for coreos configuration
ignition:
	podman run --rm --interactive --security-opt label=disable --volume "${PWD}":/pwd --workdir /pwd quay.io/coreos/butane:release ./config.bu > ./config.ign
	mkdir -p /srv/www/boot
	chown -R www-data:www-data /srv/www/

# Build custom os / Fetch most recent version of custom os
#os:
