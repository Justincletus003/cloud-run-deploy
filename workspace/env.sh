#!/bin/bash

if [ $ENV_PASS="prod" ]; then
    echo "prod env";
else
    echo "dev";
fi

echo ${_INSTANCE_CONNECTION_NAME}
echo ${DATABASE_PASS} > DB_PASS
echo ${CRED_FILE} > cloud-sa.json
