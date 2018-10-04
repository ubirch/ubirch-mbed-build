#!/bin/bash -x

CONTAINER_NAME=ubirch/ubirch-mbed-build

# build the docker container
function build_container() {

    echo "Building mbed Tools container"

    mkdir -p VAR &&
    IMAGEID=`docker build  . | grep "Successfully built" | cut -d' ' -f3`



    if [ $? -eq 0 ]; then
        echo ${GO_PIPELINE_LABEL} > VAR/${GO_PIPELINE_NAME}_${GO_STAGE_NAME}
        docker tag ${IMAGEID} ${CONTAINER_NAME}:latest
        docker tag ${IMAGEID} ${CONTAINER_NAME}:${GO_PIPELINE_LABEL:v0}
     else
        echo "Docker build failed"
        exit 1
    fi

}

# publish the new docker container
function publish_container() {
  echo "Publishing Docker Container with version: ${GO_PIPELINE_LABEL}"
  docker push ${CONTAINER_NAME}:${GO_PIPELINE_LABEL}


  if [ $? -eq 0 ]; then
    echo ${GO_PIPELINE_LABEL} > VAR/GO_PIPELINE_NAME_${GO_PIPELINE_NAME}
  else
    echo "Docker push faild"
    exit 1
  fi
  docker push ${CONTAINER_NAME}

  if [ $? -ne 0 ]; then
    echo "Docker push to tag latest failed"
    exit 1
  fi
}


case "$1" in
    build)
        build_container
        ;;
    publish)
        publish_container
        ;;
    *)
        echo "Usage: $0 {build|publish}"
        exit 1
esac

exit 0
