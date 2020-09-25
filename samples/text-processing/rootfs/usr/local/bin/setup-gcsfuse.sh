#!/usr/bin/env bash

mkdir -p "${GCS_MOUNT_DIR}"
gcsfuse -o allow_other "${GCS_BUCKET_NAME}" "${GCS_MOUNT_DIR}"
echo "Mounted succesfully FUSE bucket ${GCS_BUCKET_NAME} in ${GCS_MOUNT_DIR}"
ls "${GCS_MOUNT_DIR}"

