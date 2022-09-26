#!/bin/bash
echo ${_INSTANCE_CONNECTION_NAME}
echo ${DATABASE_PASS} > DB_PASS
echo ${CRED_FILE} > cloud-sa.json
curl -L https://github.com/golang-migrate/migrate/releases/download/$version/migrate.$platform-amd64.tar.gz | tar xvz
migrate -version