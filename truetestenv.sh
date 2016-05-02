#! /bin/bash

# Default paths to the brix working directories
TRUEAPI_PATH=~/Projects/truenum/truenumbersjsonapi/
TRUEMONGO_DATA_PATH=~/Projects/truenum/truenumbersjsonapi/localdata
DOCKER_ENGINE_IP=127.0.0.1

# include .truedevrc if it exists to redefine the variables w/ values of locations of
# working directories for the truenumbersjsonapi, etc.
if [ -f "$HOME/.truedevrc" ]
then
    . "$HOME/.truedevrc"
fi

function echosyntax() {
    echo ''
	echo 'truetestenv.sh provides an interface to create and use the containers needed to run the true number system locally.'
	echo 'The containers are:'
	echo '  truemongo-server: The mongo instance where the true numbers are stored'
	echo '  trueapi-server:  The TrueNumber server instance'
    echo ''
	echo "If the file $HOME/.truedevrc exists it will be sourced, allowing local paths to the working directories to be specified."
    echo ''
    echo 'usage:'
    echo 'build the docker trueapi-server image:       truetestenv.sh make-images'
    echo 'run the 2 needed docker containers:          truetestenv.sh initial-start'
    echo 'start the 2 docker containers:               truetestenv.sh start'
    echo 'stop the 2 docker containers:                truetestenv.sh stop'
    echo 'remove the 2 docker containers:              truetestenv.sh remove-containers'
    echo 'create the docker truenum bridge network:    truetestenv.sh create-network'
    echo 'this help:                                   truetestenv.sh --help'
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
		docker build -t truenum/trueapi docker/trueapi-server
		;;
    initial-start)
		# run the webserver for accessing the testpage at localhost/tests/integration/testpage-divs.html
		#docker run -d -p ${DOCKER_ENGINE_IP}:80:80 -v ${BRIXCLIENT_PATH}:/usr/share/nginx/html:ro --name brixclient nginx

        # run the true mongo server (attach the TRUEAPI_PATH to /app so that it is available when running a mongo shell)
		[ -d ${TRUEMONGO_DATA_PATH} ] || mkdir ${TRUEMONGO_DATA_PATH}
		docker run -d --net truenum -p ${DOCKER_ENGINE_IP}:27017:27017 -v ${TRUEAPI_PATH}:/app -v ${TRUEMONGO_DATA_PATH}:/data/db --name truemongo-server mongo

		# run the trueapi server
        docker run -d --net truenum -p ${DOCKER_ENGINE_IP}:8080:8080 -v ${TRUEAPI_PATH}:/app --name trueapi-server truenum/trueapi
		;;
    start)
		# start the containers once they've been created using initial-start
		docker start truemongo-server trueapi-server
		;;
    stop)
		# stop the running containers
		docker stop trueapi-server truemongo-server
		;;
    remove-containers)
		# remove the containers requiring that they be restarted using initial-start
		docker rm trueapi-server truemongo-server
		;;

	create-network)
		# create a bridge network for the various truenumbers servers
		docker network create --driver bridge truenum
		;;
    --help)
		# show help
		echosyntax
		;;
esac
