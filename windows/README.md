# Running MinIO as a service on Windows

## Install MinIO Service

Download the `install-service.ps1` and move it in your `minio` directory and start the powershell script.
After the script is finished, the service is available with the name `MinIO`

Start Service
```
net start MinIO
```

Stop Service
```
net stop MinIO
```

## Delete MinIO service

To delete MinIO service,

```
minio-service.exe uninstall
```


## Manual install

[winsw](https://github.com/kohsuke/winsw) is a wrapper to run any executable as an Windows service

- Download [WinSW.NET4.exe](https://github.com/kohsuke/winsw/releases/download/winsw-v2.2.0/WinSW.NET4.exe)
- Rename the `WinSW.NET4.exe` to `minio-service.exe`
- Create a xml file `minio-service.xml` insert the configuration below
- Open a `cmd` as Administrator and execute `minio-service.exe install`

```xml
<service>
  <id>MinIO</id>
  <name>MinIO</name>
  <description>MinIO is a high performance object storage server</description>
  <executable>minio.exe</executable>
  <arguments>server C:\Temp\minio</arguments>
  <logmode>rotate</logmode>
</service>
```
