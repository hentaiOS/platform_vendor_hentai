# Override host metadata to make builds more reproducible and avoid leaking info
export BUILD_USERNAME=nobody
export BUILD_HOSTNAME=android-build

# Override build number for OTA
export BUILD_NUMBER=$(date +%y%-m%d%S)
