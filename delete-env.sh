#!/bin/bash


echo Stop app
docker stop flask-application

echo Stop db
docker stop mysql-database

echo Delete app
docker rm flask-application

echo Delete db
docker rm mysql-database

rm -r database-data
