#!/bin/bash

echo Stop app
docker stop flask-application

echo Stop db
docker stop mysql-database

echo Borramos la app
docker rm flask-application

echo Borramos la db
docker rm mysql-database

echo Borramos la network
docker network rm network-flask-mysql

echo Borramos el volumen
docker volume rm database-data

echo Borramos el directory database-data 
rm -r database-data
