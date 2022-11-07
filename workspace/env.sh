#!/bin/bash

if [ $ENV_PASS="dev" ]; then
    echo "dev env";
else
    echo "prod";
fi

echo ${_INSTANCE_CONNECTION_NAME}
echo ${DATABASE_PASS} > DB_PASS
echo ${CRED_FILE} > cloud-sa.json
