#!/bin/bash
mysql -u sandbox_user -p ${_DATABASE_NAME}
if [ $? eq 0 ];
    then show databases; > databases.txt
    \q
if