#!/bin/bash

echo "hello";
echo ${_ENV_NAME}---;
echo "world";

if [ ${_ENV_NAME}="prod" ]
then
    echo "prod env";
else
    echo "dev";
fi

echo ${_INSTANCE_CONNECTION_NAME}
echo ${DATABASE_PASS} > DB_PASS
echo ${CRED_FILE} > cloud-sa.json
