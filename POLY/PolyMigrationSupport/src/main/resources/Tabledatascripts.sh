#!/bin/bash

path=`PWD`
#cd

table_name=$1
echo "table name "$table_name
file=/home/loanteam/TESTSETUP/AIRTEL/TABLEDUMP/$table_name.sql
./../../linux64/x86_64/bin/sqlc sql << logss.txt
writing  '$file' select * from $table_name
EOF
