#!/bin/bash
#REPO=$1


# Login to Docker Hub using environment variables set by Jenkins
#echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin

#docker tag karna2111/react-static-app karna2111/$REPO:latest

#docker push karna2111/$REPO:latest

#!/bin/bash

ENV=$1

if [ "$ENV" = "dev" ]; then
  docker tag react-static-app karna2111/dev:latest
  docker push karna2111/dev:latest
elif [ "$ENV" = "prod" ]; then
  docker tag react-static-app karna2111/prod:latest
  docker push karna2111/prod:latest
fi


