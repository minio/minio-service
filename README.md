# MinIO Init/Service Scripts
This project provides init/service scripts for using MinIO on various Linux and BSD distributions.

## Getting Help
Please reach us [here](https://min.io/pricing) if you need help in configuring and setting up MinIO. 

## Guidelines
The files distributed here should adhere to these principles where relevant (adjust accordingly for each system/platform):

- Don't run MinIO as root.
- Create a no-shell default user to run MinIO.
- Raise file descriptor limits to sufficiently larger values.
- Don't restart endlessly; if MinIO fails to start, there is a reason -- fix it, don't hammer it.
- Allow MinIO to re-use the same, persistent folder for TLS certificates.

## Issues
Please open an [issue](https://github.com/minio/minio/issues) on MinIO server project for bugs, enhancements regarding this project.
