#! /bin/bash

#NODE_VERSION=0.12
NODE_VERSION=5.11

# Default paths to the brix working directories
TRUEAPI_PATH=~/Projects/truenum/truenumbersjsonapi/
TRUEMONGO_DATA_PATH=~/Projects/truenum/truenumbersjsonapi/localdata
DOCKER_ENGINE_IP=

# include .truedevrc if it exists to redefine the variables w/ values of locations of
# working directories for the truenumbersjsonapi etc.
if [ -f "$HOME/.truedevrc" ]
then
    . "$HOME/.truedevrc"
fi


# It attaches to my truenumbersjsonapi repo working directory so whatever I have there is what will run
# publish the 8080 ports, so it can be accessed from the host
docker start truemongo-server
docker run --rm -it --net truenum -p 8080:8080 -v ${TRUEAPI_PATH}:/app -w /app --name trueapi-shell node:${NODE_VERSION} bash
