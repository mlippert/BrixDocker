#! /bin/bash

# This script needs enhancements. pass the container name on the commandline for one.
# Also note that it expects bunyan to be installed in the folder you're running the script
# from (npm bunyan).

CONTAINER_NAME=ips

# To pipe the stderr logs from the container to bunyan, redirect stderr to stdout, stdout to the bit bucket, and then pipe to bunyan
docker logs -f $CONTAINER_NAME 2>&1 > /dev/null | node_modules/bunyan/bin/bunyan
