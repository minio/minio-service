# Running MinIO as a service on Windows

## Install MinIO Service

[winsw](https://github.com/kohsuke/winsw) is a wrapper to run any executable as an Windows service

Copy the `install-service.ps1` in your minio directory and start the powershell script.
The service is now available with the name `MinIO`

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
