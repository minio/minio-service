# minio-systemd

Systemd script for Minio server.

## Installation

- Systemd script is configured to run the binary from /usr/local/bin/.
- Download the binary. Find the relevant links for the binary at https://minio.io/downloads/#minio-server.

```sh
$ wget -O /usr/local/bin/minio https://dl.minio.io/server/minio/release/linux-amd64/minio
```

Give execute permission to the Minio binary.

```sh
$ chmod +x /usr/local/bin/minio
```

## Create user `minio`

Systemd is configured with User=minio.

```sh
$ useradd minio
```

## Create default configuration.

Don't forget to update MINIO_VOLUMES with the correct path(s).
```
cat <<EOT >> /etc/default/minio
# Local export path.
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

Download and put `minio.service` in  `/etc/systemd/system/`
```
( cd /etc/systemd/system/; curl -O https://raw.githubusercontent.com/minio/minio/master/dist/linux-systemd/minio.service )
```

Enable startup on boot
```
systemctl enable minio.service
```

