FreeBSD service for Minio
=======================

Usage
-----

- [Download Minio](https://minio.io/downloads) in `/usr/local/bin/minio`.
- Save the FreeBSD service config file in `/etc/rc.d/minio`, configure it for your local needs.
- Ensure that config folder `/etc/minio` exists and `minio-user` user can access it.
- Ensure that export folder `/mnt/export` exists and `minio-user` user can access it.
- Edit `/etc/rc.conf` add `minio_enable="YES"`, this would enable `minio` service script.
- Now use `service minio start|stop|status` as `minio`.
