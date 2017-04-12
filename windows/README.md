# Running Minio as a service on Windows

## Install Minio Service

[NSSM](http://nssm.cc/description) is an opensource alternative to `srvany`. Download [NSSM](http://nssm.cc/download) and extract the 64 bit `nssm.exe` to a known path.

Then run the `nssm install <servicename>` command with Minio,

```
c:\nssm.exe install Minio c:\bin\minio.exe server c:\data
```

## Configure startup type

When you start services, look for the Minio service and start and stop (or make it automatically start at reboots) the service.

![Configure startup type](https://raw.githubusercontent.com/minio/minio-service/master/screenshots/windows-configure-startup-type.png)

## Configure user

It is a good (and secure) practice to create a new user, assign rights to the data folder to this user and change the service Log On info to use the newly created user.

![Configure user](https://raw.githubusercontent.com/minio/minio-service/master/screenshots/windows-configure-user.png)

## Delete Minio service

To delete Minio service, 

```
c:\nssm.exe remove Minio
```
