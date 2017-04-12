# Systemd service for Minio

Systemd script for Minio server.

## Installation

- Systemd script is configured to run the binary from /usr/local/bin/.
- Download the binary. Find the relevant links for the binary at https://minio.io/downloads/#minio-server.

## Create default configuration.

Don't forget to update MINIO_VOLUMES with the correct path.
```
cat <<EOT >> /etc/default/minio
# Local export path.
MINIO_VOLUMES="/tmp/minio/"
# Use if you want to run Minio on a custom port.
MINIO_OPTS="--address :9199"

EOT
```

## Override default keys.

By default minio reads credentials from `${HOME}/.minio/config.json`. You can
override these values by adding custom credentials in `/etc/default/minio`.

```
cat <<EOT >> /etc/default/minio
# Access Key of the server.
MINIO_ACCESS_KEY=Server-Access-Key
# Secret key of the server.
MINIO_SECRET_KEY=Server-Secret-Key

EOT
```

## Systemctl

Download `minio.service` in  `/etc/systemd/system/`
```
( cd /etc/systemd/system/; curl -O https://raw.githubusercontent.com/minio/minio-service/master/linux-systemd/minio.service )
```

### Enable startup on boot
```
systemctl enable minio.service
```

### Disable Minio service
```
systemctl disable minio.service
```

## Note

- Replace ``User=minio-user`` and ``Group=minio-user`` in minio.service file with your local setup.
- Ensure that ``MINIO_VOLUMES`` source has appropirate write access.
