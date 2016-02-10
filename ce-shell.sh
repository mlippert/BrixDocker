#! /bin/bash

#NODE_VERSION=5.6
NODE_VERSION=5

# Default paths to the brix working directories
CORRECTNESS_ENGINE_PATH=~/Projects/pearson/correctness_engine/

# include .brixdevrc if it exists to redefine the variables w/ values of locations of
# working directories for the brixclient, brixserver and correctness_engine
if [ -f "$HOME/.brixdevrc" ]
then
    . "$HOME/.brixdevrc"
fi


# It attaches to my correctness_engine repo working directory so whatever I have there is what will run
docker run --rm -it -v ${CORRECTNESS_ENGINE_PATH}:/app -w /app --name ce-shell node:${NODE_VERSION} bash
