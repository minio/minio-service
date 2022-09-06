# Systemd service for MinIO

Systemd script for MinIO server.

## Installation

- Systemd script is configured to run the binary from /usr/local/bin/.
- Systemd script is configured to run the binary as `minio-user`, make sure you create this user prior using service script.
- Download the binary. Find the relevant links for the binary at https://min.io/download/#linux.

## Create default configuration

This file serves as input to MinIO systemd service. Use this file to add `MINIO_VOLUMES` with the correct paths, `MINIO_OPTS` to add MinIO server options like `certs-dir`, `address`. MinIO credentials can be `MINIO_ROOT_USER` and `MINIO_ROOT_PASSWORD` in this file as well.

```sh
$ cat <<EOT >> /etc/default/minio
# Volume to be used for MinIO server.
MINIO_VOLUMES="/mnt/data"
# Use if you want to run MinIO on a custom port.
MINIO_OPTS="--address :9199 --console-address :9001"
# Root user for the server.
MINIO_ROOT_USER=Root-User
# Root secret for the server.
MINIO_ROOT_PASSWORD=Root-Password

# set this for MinIO to reload entries with 'mc admin service restart'
MINIO_CONFIG_ENV_FILE=/etc/default/minio
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

### Disable MinIO service
```
systemctl disable minio.service
```

## NOTE

Ensure `minio-user` is created on the host with write access to data folders.

