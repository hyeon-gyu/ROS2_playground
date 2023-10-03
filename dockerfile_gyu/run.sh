#!/bin/bash

if [ $# -ne 2 ]
then
        echo "usage: $0 <user-id> <tag-name>"
        exit
fi

# --ipc=host 


USER_ID=$1 ### 1000 or 1001
TAG_NAME=$2
REPO_NAME=ssu/misys
IMAGE=$REPO_NAME:$TAG_NAME

XSOCK=/tmp/.X11-unix
XAUTH=$XAUTHORITY 
VULCAN=/usr/share/vulkan
SHARED_DOCK_DIR=/home/$USER/shared_dir
SHARED_HOST_DIR=/home/$USER/shared_dir

DEVICES="--device /dev/snd"

### The following volume mapping is necessary 
### for ros2 nodes in different containers to communicate,
### where one of them uses FastDDS.
### FastDDS uses the feature of shared memory 
### when two nodes are detected as running on the same host:
### --volume=/dev/shm:/dev/shm:rw

VOLUMES="--volume=$XSOCK:$XSOCK:ro	 
	 --volume=$XAUTH:$XAUTH:ro
	 --volume=$VULCAN:$VULCAN:ro
	 --volume=$SHARED_HOST_DIR:$SHARED_DOCK_DIR:rw
	 --volume=/media:/media:rw
	 --volume=/dev/shm:/dev/shm:rw
	 --volume=/dev/ttyUSB0:/dev/ttyUSB0:ro
  	 --volume=/dev/video*:/dev/video* "
	 
ENVIRONS="--env DISPLAY=$DISPLAY
	  --env SDL_VIDEODRIVER=x11
	  --env XAUTHORITY=$XAUTHORITY"

GPU='--gpus all,"capabilities=graphics,utility,display,video,compute"' 

NVIDIA="--runtime=nvidia"

FULL_CMD="docker run -it \
	-u $USER_ID \
	--privileged \
	--net=host \
	$GPU \
	$DEVICES \
	$ENVIRONS \
	$VOLUMES \
	$NVIDIA \
	$IMAGE"	  

echo $FULL_CMD

docker run -it \
	-u $USER_ID \
	--privileged \
	--net=host \
	$GPU \
	$DEVICES \
	$ENVIRONS \
	$VOLUMES \
	$NVIDIA \
	$IMAGE	  

