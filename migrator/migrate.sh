#!/bin/bash
echo ${DATABASE_PASS}
docker --version

#docker run  --network host migrator -path=/migrations/ -database "mysql://docker:docker@localhost:7557/test_db?sslmode=disable" up