# Systemd service for MinIO AIStor

Systemd script for Distributed MinIO AIStor server.

## Installation

- Systemd script is configured to run the binary from /usr/local/bin/.
- Systemd script is configured to run the binary as `minio-user`, make sure you create this user prior using service script.
- Download the binary. Find the relevant links for the binary at https://min.io/download#/linux.

## Create the Environment configuration file

MinIO AIStor uses a two-file configuration approach to ensure that configuration changes (including variable removals) are properly synchronized when using `mc admin service restart`.

### /etc/default/minio

This file is loaded by systemd and should contain only the variables needed for service startup and the pointer to the main configuration file:

```sh
cat <<EOT >> /etc/default/minio
# Remote volumes to be used for MinIO server.
MINIO_VOLUMES=http://node{1...6}/export{1...32}
# Use if you want to run MinIO on a custom port.
MINIO_OPTS="--address :9000 --console-address :9001"
# Pointer to the main configuration file
MINIO_CONFIG_ENV_FILE=/etc/minio/config.env
EOT
```

### /etc/minio/config.env

This file contains all other MinIO configuration variables. Changes to this file (including removals) take effect after `mc admin service restart` without requiring `systemctl restart minio.service`:

```sh
mkdir -p /etc/minio
cat <<EOT >> /etc/minio/config.env
# Root credentials
MINIO_ROOT_USER=Root-User
MINIO_ROOT_PASSWORD=Root-Password

# Add other MinIO configuration here
# MINIO_IDENTITY_LDAP_SERVER_ADDR=ldap.example.com:636
# MINIO_IDENTITY_LDAP_LOOKUP_BIND_DN=cn=admin,dc=example,dc=com
EOT
```

Set appropriate permissions:

```sh
chmod 600 /etc/minio/config.env
chown minio-user:minio-user /etc/minio/config.env
```

For distributed setup, copy both configuration files across all nodes to have consistent credentials and settings.

## Why Two Files?

When MinIO AIStor starts, it captures the systemd environment in `startupEnvironment`. On `mc admin service restart`, the process restarts with this captured environment, then re-reads `MINIO_CONFIG_ENV_FILE`.

- Variables in `/etc/default/minio` persist across restarts (part of `startupEnvironment`)
- Variables in `/etc/minio/config.env` are re-read fresh each restart

This means removing a variable from `/etc/minio/config.env` and running `mc admin service restart` will properly remove it from the running configuration. If the variable were in `/etc/default/minio`, you would need `systemctl restart minio.service` to remove it.

## Systemctl

Download `minio.service` in `/lib/systemd/system/`

```sh
curl -O https://raw.githubusercontent.com/minio/minio-service/master/linux-systemd/distributed/minio.service
sudo mv minio.service /lib/systemd/system/
sudo systemctl daemon-reload
```

### Enable startup on boot

```sh
systemctl enable minio.service
```

## Linux Capabilities

The service file includes the following ambient capabilities:

| Capability             | Purpose                                                 |
| ---------------------- | ------------------------------------------------------- |
| `CAP_NET_BIND_SERVICE` | Bind to privileged ports (< 1024)                       |
| `CAP_SYS_ADMIN`        | S.M.A.R.T. disk health monitoring (NVMe admin commands) |
| `CAP_DAC_OVERRIDE`     | S.M.A.R.T. disk health monitoring (open block devices)  |

If you're running MinIO outside of systemd, set the capabilities on the binary:

```sh
sudo setcap 'cap_net_bind_service,cap_sys_admin,cap_dac_override=+ep' /usr/local/bin/minio
```

For privileged port binding only:

```sh
sudo setcap cap_net_bind_service=+ep /usr/local/bin/minio
```

## NOTE

Ensure `minio-user` is created on all the hosts in distributed setup with write access to data folders and the configuration file.
