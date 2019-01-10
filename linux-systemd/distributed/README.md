# Systemd service for Minio

Systemd script for Distributed Minio server.

## Installation

- Systemd script is configured to run the binary from /usr/local/bin/.
- Download the binary. Find the relevant links for the binary at https://minio.io/downloads/#minio-server.

## Create the Environment configuration file

This file serves as input to Minio systemd service. Use this file to add `MINIO_VOLUMES` with the correct paths,
`MINIO_OPTS` to add Minio server options like `certs-dir`, `address`. Minio credentials should be
`MINIO_ACCESS_KEY` and `MINIO_SECRET_KEY` in this file as well.

```sh
$ cat <<EOT >> /etc/default/minio
# Remote volumes to be used for Minio server.
MINIO_VOLUMES=http://node1/export1 http://node2/export2 http://node3/export3 http://node4/export4
# Use if you want to run Minio on a custom port.
MINIO_OPTS="--address :9199"
# Access Key of the server.
MINIO_ACCESS_KEY=Server-Access-Key
# Secret key of the server.
MINIO_SECRET_KEY=Server-Secret-Key

EOT
```

For distributed setup it is required to copy this file across all nodes to have consistent credentials.

## Systemctl

Download `minio.service` in  `/etc/systemd/system/`

```
( cd /etc/systemd/system/; curl -O https://raw.githubusercontent.com/minio/minio-service/master/linux-systemd/distributed/minio.service )
```

Enable startup on boot

```
systemctl enable minio.service
```
