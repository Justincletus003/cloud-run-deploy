#!/bin/bash
echo ${_INSTANCE_CONNECTION_NAME}
export DB_PASS=${DATABASE_PASS}
echo ${CRED_FILE} > cloud-sa.json

# /workspace/cloud_sql_proxy -dir=/workspace -instances=${_INSTANCE_CONNECTION_NAME} -credential_file=${CRED_FILE} & sleep 2