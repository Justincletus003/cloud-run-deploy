#!/bin/bash
# echo ${CRED_FILE}
echo ${_INSTANCE_CONNECTION_NAME}
echo ${INSTANCE_CONNECTION_NAME}
/workspace/cloud_sql_proxy -dir=/workspace -instances=${_INSTANCE_CONNECTION_NAME} -credential_file=${CRED_FILE} & sleep 2