# run project

    docker run --name mysql -p 3306:3306 -e MYSQL_ALLOW_EMPTY_PASSWORD=true -e MYSQL_USER=root -d mysql:8.0.16
    docker run --name mongo -p 27017:27017 -d mongo:4
