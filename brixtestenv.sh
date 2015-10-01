#! /bin/bash

# So I think this script should be named:
# brixtestenv.sh
#
# Syntax:
# brixtestenv.sh make-images
# brixtestenv.sh initial-start
# brixtestenv.sh start
# brixtestenv.sh stop
# brixtestenv.sh remove-containers


# What I've got so far:

# Create the docker images
docker build -t brix/brixce brixce
docker build -t brix/brixserver brixserver

# The brixserver will need to link to the redis-server and the brixCE so create them first

# Create a webserver for the brixclient

# To run the brixclient webserver for accessing the testpage at localhost/tests/integration/testpage-divs.html
docker run -d -p 127.0.0.1:80:80 -v ~/Projects/pearson/brixclient:/www --name brixclient fnichol/uhttpd

# To run the redis server
docker run -d --name redis-server redis

# To run the correctness engine
docker run -d -v ~/Projects/pearson/correctness_engine:/app --name brixCE brix/brixce

# It attaches to my brixserver repo working directory so whatever I have there is what will run
docker run -d --link redis-server --link brixCE -p 127.0.0.1:8088:8088 -v ~/Projects/pearson/brixserver:/app --name ips brix/brixserver


# To start the containers once they've been created using the above run commands
docker start redis-server brixclient brixCE ips

# To stop the running containers
docker stop ips brixCE redis-server brixclient
