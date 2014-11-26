#!/bin/bash

read -p "Gibbix Passwort: " -s PWD;
echo;

for p in $(ls -1 | grep proj_)
do
    echo "reading -> $p/00_create.sql ..."
    cat $p/00_create.sql | mysql -uvmuser --password=$PWD
done
