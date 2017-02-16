Upstart service for Minio
=====================

Usage
-----

- [Download Minio](https://minio.io/downloads) in `/usr/local/bin/minio`.
- Execute `sudo setcap cap_net_bind_service=+ep /usr/local/bin/minio`.
- Ensure that config folder `/etc/minio` exists and `minio-user` can access it.
- Ensure that export folder `/mnt/export` exists and `minio-user` can access it.
- Save the appropriate upstart config file in `/etc/init/minio.conf`.
- Now you can use `sudo service minio start|stop|restart`.

