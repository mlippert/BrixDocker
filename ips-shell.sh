#! /bin/bash

# There are some issues w/ PI using the latest version (4+) version of nodejs (integration tests fail) -mjl 11/16/2015
NODE_VERSION=0.12
#NODE_VERSION=4.1.2

# Default paths to the brix working directories
BRIXSERVER_PATH=~/Projects/pearson/brixserver/

# include .brixdevrc if it exists to redefine the variables w/ values of locations of
# working directories for the brixclient, brixserver and correctness_engine
if [ -f "$HOME/.brixdevrc" ]
then
    . "$HOME/.brixdevrc"
fi


# It attaches to my brixserver repo working directory so whatever I have there is what will run
# publish the 8088 & 8080 ports, so they can be accessed from the host (the former is the port usually
# set by local ips config, while the latter is used by the deployed ips servers)
docker start redis-server brixCE
docker run --rm -it --link redis-server --link brixCE -p 8088:8088 -p 8080:8080 -v ${BRIXSERVER_PATH}:/app -w /app --name ips-shell node:${NODE_VERSION} bash
