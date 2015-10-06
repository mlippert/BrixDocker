#! /bin/bash

#NODE_VERSION=0.10
NODE_VERSION=4.1.2

# It attaches to my brixserver repo working directory so whatever I have there is what will run
docker start redis-server brixCE
docker run --rm -it --link redis-server --link brixCE -v ~/Projects/pearson/brixserver:/app --name ips-shell node:${NODE_VERSION} bash
