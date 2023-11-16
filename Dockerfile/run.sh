#!/bin/bash

if [ $# -ne 2 ]
then
        echo "usage: $0 <user-id> <tag-name>"
        exit
fi

# --ipc=host 


USER_ID=$1 ### 1000 or 1001
TAG_NAME=$2
REPO_NAME=awws
IMAGE=$REPO_NAME:$TAG_NAME

XSOCK=/tmp/.X11-unix
XAUTH=$XAUTHORITY 
VULCAN=/usr/share/vulkan
SHARED_DOCK_DIR=/home/autoware/shared_dir
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
	 --volume=/dev/video0:/dev/video0:rw
	 --volume=/dev/video1:/dev/video1:rw
	 --volume=/dev/video2:/dev/video2:rw
	 --volume=/dev/video3:/dev/video3:rw
	 --volume=/dev/video4:/dev/video4:rw
	 --volume=/dev/video5:/dev/video5:rw
	 --volume=/dev/iio/device0:/dev/iio/device0:rw
	 --volume=/dev/iio/device1:/dev/iio/device1:rw
	 --volume=/sys/devices/platform/3610000.xhci:/sys/devices/platform/3610000.xhci:rw
	 --volume=/dev/ttyACM0:/dev/ttyACM0:rw"
	 
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


###sudo chown -R $USER:$USER /sys/devices/platform/3610000.xhci/usb2/2-3/2-3.4/2-3.4\:1.5/0003\:8086\:0B5C.000B/HID-SENSOR-200073.2.auto/iio\:device0/
###sudo chown -R $USER:$USER /sys/devices/platform/3610000.xhci/usb2/2-3/2-3.4/2-3.4\:1.5/0003\:8086\:0B5C.000B/HID-SENSOR-200076.3.auto/iio\:device1/
# sudo chown -R $USER:$USER /dev/iio:device1
# sudo chown -R $USER:$USER /dev/iio:device0