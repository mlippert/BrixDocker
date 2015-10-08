#! /bin/bash

#NODE_VERSION=0.10
NODE_VERSION=4.1.2

# Default paths to the brix working directories
BRIXSERVER_PATH=~/Projects/pearson/brixserver/

# include .brixdevrc if it exists to redefine the variables w/ values of locations of
# working directories for the brixclient, brixserver and correctness_engine
if [ -f "$HOME/.brixdevrc" ]
then
    . "$HOME/.brixdevrc"
fi


# It attaches to my brixserver repo working directory so whatever I have there is what will run
docker start redis-server brixCE
docker run --rm -it --link redis-server --link brixCE -v ${BRIXSERVER_PATH}:/app --name ips-shell node:${NODE_VERSION} bash
