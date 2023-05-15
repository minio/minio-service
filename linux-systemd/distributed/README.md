# Systemd service for MinIO

Systemd script for Distributed MinIO server.

## Installation

- Systemd script is configured to run the binary from /usr/local/bin/.
- Systemd script is configured to run the binary as `minio-user`, make sure you create this user prior using service script.
- Download the binary. Find the relevant links for the binary at https://min.io/download#/linux.

## Create the Environment configuration file

This file serves as input to MinIO systemd service. Use this file to add `MINIO_VOLUMES` with the correct paths, `MINIO_OPTS` to add MinIO server options like `certs-dir`, `address`. MinIO credentials should be `MINIO_ROOT_USER` and `MINIO_ROOT_PASSWORD` in this file as well.

```sh
$ cat <<EOT >> /etc/default/minio
# Remote volumes to be used for MinIO server.
MINIO_VOLUMES=http://node{1...6}/export{1...32}
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

For distributed setup it is required to copy this file across all nodes to have consistent credentials.

## Systemctl

Download `minio.service` in  `/lib/systemd/system/`

```
( cd /lib/systemd/system/; curl -O https://raw.githubusercontent.com/minio/minio-service/master/linux-systemd/distributed/minio.service )
```

Enable startup on boot

```
systemctl enable minio.service
```

## NOTE

Ensure `minio-user` is created on all thes hosts in distributed setup with write access to data folders.
