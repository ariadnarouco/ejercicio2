#!/bin/bash

echo "Script starting..."

DATABASE_DIR="database-data"

if [ -d ${DATABASE_DIR} ] 
then
    echo "Directory ${DATABASE_DIR} exists. :)" 
else
    mkdir ${DATABASE_DIR}
    echo "Directory ${DATABASE_DIR} created. :)" 
fi



PWD=$(pwd)
NETWORK_NAME="network-flask-mysql"

echo "Creating secured network : ${NETWORK_NAME}"
docker network create ${NETWORK_NAME}

MYSQL_ROOT_PASSWORD="secret"
MYSQL_DATABASE="test_db"
PORTS="3307:3306"
VOLUME="$PWD/school.sql:/school.sql"
MYSQL_HOST="mysql"

DATABASE_NAME="mysql-database"

echo "Running Database..."
docker run --name ${DATABASE_NAME} -d -e MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD} -e MYSQL_DATABASE=${MYSQL_DATABASE} -p ${PORTS} -v ${PWD}/${DATABASE_DIR}:/var/lib/mysql --network ${NETWORK_NAME} --network-alias mysql -v ${VOLUME} --restart always mysql:5.7






APP_NAME="flask-application"
echo "Bulding app..."
docker build -t ${APP_NAME} -f Dockerfile-app .

echo "Running app"
docker run -d --name ${APP_NAME} -e MYSQL_DATABASE_USER=root -e MYSQL_DATABASE_PASSWORD=${MYSQL_ROOT_PASSWORD} -e MYSQL_DATABASE_DB=${MYSQL_DATABASE} -e MYSQL_DATABASE_HOST=${MYSQL_HOST} --network ${NETWORK_NAME} -p 8081:8081  ${APP_NAME}
