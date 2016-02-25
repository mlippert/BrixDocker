#! /bin/bash

# Note that this script expects bunyan to be installed in the folder you're running the script
# from (npm bunyan).

# Container name is 1st argument, defaults to ips if not given
CONTAINER_NAME=${1:-ips}

# To pipe the stderr logs from the container to bunyan, redirect stderr to stdout, stdout to the bit bucket, and then pipe to bunyan
docker logs -f $CONTAINER_NAME 2>&1 > /dev/null | node_modules/bunyan/bin/bunyan
