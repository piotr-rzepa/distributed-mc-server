#!/bin/bash

while getopts 'f:t:b:m:h' opt; do
  case "$opt" in
    f)
      DOCKERFILE_PATH="$OPTARG"
      ;;

    t)
      IMAGE_TAG="$OPTARG"
      ;;

    b)
      MULTIPAPER_BUILD_VERSION="$OPTARG"
      ;;
    
    m)
      MULTIPAPER_MC_VERSION="$OPTARG"
      ;;
   
    ?|h)
      echo "Usage: $(basename $0) [-f arg] [-t arg] [-b arg] [-m arg]"
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"

docker build -f $DOCKERFILE_PATH -t $IMAGE_TAG --build-arg MULTIPAPER_MC_VERSION=$MULTIPAPER_MC_VERSION --build-arg MULTIPAPER_BUILD_VERSION=$MULTIPAPER_BUILD_VERSION .
