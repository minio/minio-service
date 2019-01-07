# Systemd service for Minio

Systemd script for Minio server.

## Installation

- Systemd script is configured to run the binary from /usr/local/bin/.
- Download the binary. Find the relevant links for the binary at https://minio.io/downloads/#minio-server.

## Create default configuration

This file serves as input to Minio systemd service. Use this file to add `MINIO_VOLUMES` with the correct paths,
`MINIO_OPTS` to add Minio server options like `certs-dir`, `address`. Minio credentials can be
`MINIO_ACCESS_KEY` and `MINIO_SECRET_KEY` in this file as well.

```sh
$ cat <<EOT >> /etc/default/minio
# Volume to be used for Minio server.
MINIO_VOLUMES="/tmp/minio/"
# Use if you want to run Minio on a custom port.
MINIO_OPTS="--address :9199"
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
