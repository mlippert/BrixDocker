#! /bin/bash

# Default paths to the brix working directories
BRIXCLIENT_PATH=~/Projects/pearson/brixclient/
BRIXSERVER_PATH=~/Projects/pearson/brixserver/
CORRECTNESS_ENGINE_PATH=~/Projects/pearson/correctness_engine/
MOCKSERVER_PATH=~/Projects/pearson/mockendpointserver/
BRIXCLIENT_IP=
BRIXSERVER_IP=
CORRECTNESS_ENGINE_IP=
MOCKSERVER_IP=

# include .brixdevrc if it exists to redefine the variables w/ values of locations of
# working directories for the brixclient, brixserver and correctness_engine
if [ -f "$HOME/.brixdevrc" ]
then
    . "$HOME/.brixdevrc"
fi

function echosyntax() {
    echo ''
	echo 'brixtestenv.sh provides an interface to create and use the 4 containers needed to test the brix system.'
	echo 'The 5 containers are:'
	echo '  redis-server: The redis instance needed by the brixserver for its cache'
	echo '  brixCE:       The correctness engine used by the brixserver when processing submissions'
	echo '  ips:          The brixserver instance targeted by the testpage provided by the brixclient webserver instance'
	echo '  brixclient:   The webserver providing the brixclient testpage at http://localhost/tests/integration/testpage-divs.html'
	echo '  mockserver:   The mock endpoint server which provides responses to the endpoints used by the ips when processing requests'
    echo ''
	echo "If the file $HOME/.brixdevrc exists it will be sourced, allowing local paths to the working directories to be specified."
    echo ''
    echo 'usage:'
    echo 'build the docker brixce, brixserver'
    echo '    & mockserver images:                     brixtestenv.sh make-images'
    echo 'run the 5 docker containers:                 brixtestenv.sh initial-start'
    echo 'start the 5 docker containers:               brixtestenv.sh start'
    echo 'stop the 5 docker containers:                brixtestenv.sh stop'
    echo 'remove the 5 docker containers:              brixtestenv.sh remove-containers'
    echo 'create the docker brix bridge network:       brixtestenv.sh create-network'
    echo 'this help:                                   brixtestenv.sh --help'
}

if [ $# -ne 1 ]
then
    echo 'Wrong number of arguments'
    echosyntax
    exit 1
fi

case $1 in
    make-images)
		# Create the docker images
		docker build -t brix/brixce brixce
		docker build -t brix/brixserver brixserver
		docker build -t brix/mockserver mockserver
		;;
    initial-start)
		# run the brixclient webserver for accessing the testpage at localhost/tests/integration/testpage-divs.html
		docker run -d -p ${BRIXCLIENT_IP}:80:80 -v ${BRIXCLIENT_PATH}:/usr/share/nginx/html:ro --name brixclient nginx

		# run the redis server
		docker run -d --net brix --name redis-server redis

		# run the mockendpointserver to mock the policy and scoring endpoints used by the ips
		docker run -d --net brix -p ${MOCKSERVER_IP}:9099:9099 -v ${MOCKSERVER_PATH}:/app  --name mockserver brix/mockserver

		# run the correctness engine
		docker run -d --net brix -p ${CORRECTNESS_ENGINE_IP}:8090:8090 -v ${CORRECTNESS_ENGINE_PATH}:/app --name brixCE brix/brixce

		# run the ips
		docker run -d --net brix -p ${BRIXSERVER_IP}:8088:8088 -v ${BRIXSERVER_PATH}:/app --name ips brix/brixserver
		;;
    start)
		# start the containers once they've been created using initial-start
		docker start brixclient redis-server mockserver brixCE ips
		;;
    stop)
		# stop the running containers
		docker stop ips brixCE mockserver redis-server brixclient
		;;
    remove-containers)
		# remove the containers requiring that they be restarted using initial-start
		docker rm ips brixCE mockserver redis-server brixclient
		;;

	create-brixnetwork)
		# create a bridge network for the various brix servers
		docker network create --driver bridge brix
		;;
    --help)
		# show help
		echosyntax
		;;
esac
