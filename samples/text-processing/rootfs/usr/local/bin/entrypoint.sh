#!/usr/bin/env bash

if [[ -n "${GCS_MOUNT_DIR}" ]] && [[ -n "${GCS_BUCKET_NAME}" ]] ; then
    bash /usr/local/bin/setup-gcsfuse.sh
fi

python3 $@
