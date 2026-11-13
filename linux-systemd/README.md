# Systemd service for MinIO AIStor

Systemd script for MinIO AIStor server.

## Installation

- Systemd script is configured to run the binary from /usr/local/bin/.
- Systemd script is configured to run the binary as `minio-user`, make sure you create this user prior using service script.
- Download the binary. Find the relevant links for the binary at https://min.io/download/#linux.

## Create the Environment configuration file

MinIO AIStor uses a two-file configuration approach to ensure that configuration changes (including variable removals) are properly synchronized when using `mc admin service restart`.

### /etc/default/minio

This file is loaded by systemd and should contain only the variables needed for service startup and the pointer to the main configuration file:

```sh
cat <<EOT >> /etc/default/minio
# Volume to be used for MinIO server.
MINIO_VOLUMES="/mnt/data"
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

## Why Two Files?

When MinIO AIStor starts, it captures the systemd environment in `startupEnvironment`. On `mc admin service restart`, the process restarts with this captured environment, then re-reads `MINIO_CONFIG_ENV_FILE`.

- Variables in `/etc/default/minio` persist across restarts (part of `startupEnvironment`)
- Variables in `/etc/minio/config.env` are re-read fresh each restart

This means removing a variable from `/etc/minio/config.env` and running `mc admin service restart` will properly remove it from the running configuration. If the variable were in `/etc/default/minio`, you would need `systemctl restart minio.service` to remove it.

## Systemctl

Download `minio.service` in `/lib/systemd/system/`

```sh
curl -O https://raw.githubusercontent.com/minio/minio-service/master/linux-systemd/minio.service
sudo mv minio.service /lib/systemd/system/
sudo systemctl daemon-reload
```

### Enable startup on boot

```sh
systemctl enable minio.service
```

### Disable MinIO service

```sh
systemctl disable minio.service
```

## Linux Capabilities

The service file includes the following ambient capabilities:

| Capability             | Purpose                                                  |
| ---------------------- | -------------------------------------------------------- |
| `CAP_NET_BIND_SERVICE` | Bind to privileged ports (< 1024)                        |
| `CAP_SYS_ADMIN`        | S.M.A.R.T. disk health monitoring (NVMe admin commands)  |
| `CAP_DAC_OVERRIDE`     | S.M.A.R.T. disk health monitoring (open block devices)   |
| `CAP_SYS_RESOURCE`     | Lets the AIStor Files gateway mark itself an I/O flusher |

These capabilities are all the service can ever hold, and the service file
limits what they reach:

- `CAP_DAC_OVERRIDE` cannot change system files: `/usr`, `/boot` and `/etc` are
  read-only for the service, except `/usr/local/bin`, where an in-place update
  replaces the binary, and `/etc/minio`. `/etc/shadow`, `/etc/gshadow`, sudo
  rules, `/root` and the users' crontabs in `/var/spool/cron` are not visible to
  it. Block devices are read-only, so it cannot write a disk directly either;
  S.M.A.R.T. monitoring only reads them. `CAP_SYS_ADMIN`, which S.M.A.R.T. needs
  for NVMe health logs, still lets the process send any NVMe passthrough
  command, writes included; remove `CAP_SYS_ADMIN` from `AmbientCapabilities`
  in a drop-in if you do not need S.M.A.R.T. on NVMe drives.
- `CAP_SYS_ADMIN` cannot undo that: the service may not mount file systems or
  create namespaces.
- `LimitMEMLOCK=infinity` lets RDMA pin its buffers without root, so the same
  service file serves nodes with and without RDMA.

If the data folders live elsewhere under `/usr` or `/etc`, add them to
`ReadWritePaths` in a drop-in (`systemctl edit minio`). If the binary lives
elsewhere, the drop-in sets `AssertFileIsExecutable` and `ExecStart` to its path,
and, when its directory is under `/usr` or `/etc`, adds that directory to
`ReadWritePaths` so in-place updates can replace it:

```ini
[Unit]
AssertFileIsExecutable=
AssertFileIsExecutable=/opt/minio/bin/minio

[Service]
ExecStart=
ExecStart=/opt/minio/bin/minio server $MINIO_OPTS $MINIO_VOLUMES
```

If you're running MinIO outside of systemd, set the capabilities on the binary:

```sh
sudo setcap 'cap_net_bind_service,cap_sys_admin,cap_dac_override=+ep' /usr/local/bin/minio
```

For privileged port binding only:

```sh
sudo setcap cap_net_bind_service=+ep /usr/local/bin/minio
```

## NOTE

Ensure `minio-user` is created on the host with write access to data folders and the configuration file.
