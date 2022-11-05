# Override host metadata to make builds more reproducible and avoid leaking info
export BUILD_USERNAME=nobody
export BUILD_HOSTNAME=android-build

# Override build number to avoid leaking user information and provide incremental build number for OTA
export BUILD_NUMBER=$(date +%m%d%H%M)
