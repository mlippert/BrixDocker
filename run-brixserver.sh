#! /bin/bash

# What I've got so far:
# The brixserver will need to link to the redis-server and the brixCE so create them first

# To run the redis server
docker run -d --name redis-server redis

# To run the correctness engine
docker run -d -v ~/Projects/pearson/correctness_engine:/app --name brixCE mjl/brixce

# It attaches to my brixserver repo working directory so whatever I have there is what will run
docker run -d --link redis-server --link brixCE -v ~/Projects/pearson/brixserver:/app --name ips mjl/brixserver

# Lastly create a webserver for the brixclient linking it to the brixserver

# To run the brixclient webserver for accessing the testpage at localhost/tests/integration/testpage-divs.html
docker run -d -p 127.0.0.1:80:80 --link ips -v ~/Projects/pearson/brixclient:/www --name brixclient fnichol/uhttpd
