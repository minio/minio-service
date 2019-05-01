# Systemd service for MinIO

Systemd script for MinIO server.

## Installation

- Systemd script is configured to run the binary from /usr/local/bin/.
- Download the binary. Find the relevant links for the binary at https://min.io/download/#linux.

## Create default configuration

This file serves as input to MinIO systemd service. Use this file to add `MINIO_VOLUMES` with the correct paths, `MINIO_OPTS` to add MinIO server options like `certs-dir`, `address`. MinIO credentials can be `MINIO_ACCESS_KEY` and `MINIO_SECRET_KEY` in this file as well.

```sh
$ cat <<EOT >> /etc/default/minio
# Volume to be used for MinIO server.
MINIO_VOLUMES="/tmp/minio/"
# Use if you want to run MinIO on a custom port.
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
Note: If you want to bind to a port < 1024 with the service running as a regular user, you will need to add bind capability via the AmbientCapabilities directive in the minio.service file:

```
[Service]
AmbientCapabilities=CAP_NET_BIND_SERVICE
WorkingDirectory=/usr/local/
```
### Enable startup on boot
```
systemctl enable minio.service
```

### Disable MinIO service
```
systemctl disable minio.service
```

## Note

- Replace ``User=minio-user`` and ``Group=minio-user`` in minio.service file with your local setup.
- Ensure that ``MINIO_VOLUMES`` source has appropirate write access.
