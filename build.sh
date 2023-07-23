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
      MPAPER_BUILD_VERSION="$OPTARG"
      ;;
    
    m)
      MPAPER_MINECRAFT_VERSION="$OPTARG"
      ;;
   
    ?|h)
      echo "Usage: $(basename $0) [-f arg] [-t arg] [-b arg] [-m arg]"
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"

docker build -f $DOCKERFILE_PATH -t $IMAGE_TAG --build-arg MPAPER_MC_VER=$MPAPER_MINECRAFT_VERSION --build-arg MPAPER_BUID_VER=$MPAPER_BUILD_VERSION .
