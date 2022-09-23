#!/bin/bash
# echo ${DATABASE_PASS}

docker run  --network host migrator -path=/migrations/ -database "mysql://${DATABASE_USER}:${DATABASE_PASS}@localhost:3306/test_db?sslmode=disable" up