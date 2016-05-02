#! /bin/bash

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


# Run the bash shell inside the running truemongo-server container
# from there you can for example run the mongo shell or mongoimport
docker exec -it truemongo-server bash
