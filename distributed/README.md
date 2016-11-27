# minio-systemd

Systemd script for Distributed Minio server.

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

## Create the Environment configuration file.

Don't forget to update MINIO_VOLUMES with the correct path(s).

```sh
$ cat <<EOT >> /etc/default/minio
# Remote node configuration.
MINIO_VOLUMES=http://node1/export1 http://node2/export2 http://node3/export3 http://node4/export4
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

