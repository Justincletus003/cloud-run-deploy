#!/bin/bash
# echo ${DATABASE_PASS}
host="/cloudsql/pantheon-lighthouse-poc:us-central1:lighthousedb"
dbURL=mysql://${DATABASE_USER}:${DATABASE_PASS}@unix

dbURI := fmt.Sprintf("%s:%s@unix(/%s)/%s?parseTime=true&multiStatements=true", user, password, host, dbname)
docker run  --network host migrator -path=/migrations/ -database "mysql://${DATABASE_USER}:${DATABASE_PASS}@localhost:3306/test_db?sslmode=disable" up