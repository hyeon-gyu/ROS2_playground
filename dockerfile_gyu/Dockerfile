# Image name: awws:foxy-f1t
# docker build -t awws:foxy-f1t --build-arg USER=autoware .
# ./run.sh 1000 f1t-foxy

# alias f1t-foxy='docker run --privileged -it -u 1000 -e SDL_VIDEODRIVER=x11 -e DISPLAY=$DISPLAY -e XAUTHORITY=$XAUTHORITY -v /tmp/.X11-unix:/tmp/.X11-unix -v $XAUTHORITY:$XAUTHORITY -v /usr/share/vulkan:/usr/share/vulkan -v /home/$USER/shared_dir:/home/$USER/shared_dir -v /dev:/dev --ipc=host --gpus '\''all,"capabilities=graphics,utility,display,video,compute"'\'' --net=host --runtime=nvidia ssu/misys:foxy-f1t-tutor-user'

FROM nvcr.io/nvidia/l4t-base:r35.1.0
ARG USER

### install Sudo option
RUN apt update && apt -y upgrade
RUN apt install sudo

RUN echo "${USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

### run under the name of $USER
USER $USER 

### create a default user
RUN sudo adduser $USER && sudo adduser $USER sudo && sudo adduser $USER audio && sudo adduser $USER systemd-timesync && sudo adduser $USER video

### set Locale
RUN sudo apt update && sudo apt install locales
RUN sudo locale-gen en_US en_US.UTF-8 && sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
RUN export LANG=en_US.UTF-8

### set Sources
RUN sudo apt install -y software-properties-common && sudo add-apt-repository universe
RUN sudo apt update && sudo apt install curl -y
RUN sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

### install ROS2 packages
RUN sudo apt update && sudo apt -y upgrade
RUN sudo apt install -y ros-foxy-desktop python3-argcomplete
RUN sudo apt install -y ros-dev-tools
RUN /bin/bash -c "source /opt/ros/foxy/setup.bash"

### install vim , git
RUN sudo apt-get update && sudo apt-get install -y vim && sudo apt-get install -y git

### fix pip3-related bugs
RUN sudo mv /usr/local/lib/python3.8/dist-packages /usr/local/lib/python3.8/dist-packages.old
RUN sudo ln -s /usr/lib/python3/dist-packages/ /usr/local/lib/python3.8/dist-packages
RUN sudo apt-get update
RUN sudo apt-get install -y python3-pip && sudo pip3 install --upgrade pip
RUN sudo mv /usr/bin/pip /usr/bin/pip.old && sudo mv /usr/bin/pip3 /usr/bin/pip3.old
RUN sudo ln -s /usr/local/bin/pip /usr/bin/pip && sudo ln -s /usr/local/bin/pip3 /usr/bin/pip3

### legacy packages from foxy-carla
# RUN pip3 install --user pygame
# RUN pip3 install --user numpy==1.18.4

### edit .bashrc for environment setting
WORKDIR /home/$USER
RUN touch bashrc.foxy-tutor
RUN echo "source /opt/ros/foxy/setup.bash" >> bashrc.foxy-tutor && echo "source /usr/share/colcon_cd/function/colcon_cd.sh" >> bashrc.foxy-tutor && echo "source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash" >> bashrc.foxy-tutor
RUN echo "export PATH=\$PATH:~/.local/bin" >> bashrc.foxy-tutor
RUN echo "source /home/$USER/bashrc.foxy-tutor" >> ~/.bashrc

#############################################################
### ROS2 tutorials for foxy distro
#############################################################

### Beginner: CLI tools
RUN sudo apt update && sudo apt install -y ros-foxy-turtlesim && sudo apt install -y ~nros-foxy-rqt* && sudo apt-get install wget

### Beginner: Client libraries

##### Using colcon to build packages
RUN sudo apt install -y python3-colcon-common-extensions && mkdir -p /home/${USER}/ros2_ws/src
WORKDIR /home/$USER/ros2_ws
RUN sudo git clone https://github.com/ros2/examples src/examples -b foxy
WORKDIR /home/$USER/ros2_ws/

##### Creating a workspace
RUN /bin/bash -c "source /opt/ros/foxy/setup.bash"
WORKDIR /home/$USER/ros2_ws/src
RUN sudo git clone https://github.com/ros/ros_tutorials.git -b foxy-devel

WORKDIR /home/$USER/ros2_ws
RUN sudo rosdep init
RUN rosdep update --include-eol-distros && rosdep install -i --from-path src --rosdistro foxy -y

###----------------------------------------------------------------------------
### Beginner: Client libraries
### Beginner: Client libraries: Creating a package
### Beginner: Client libraries: Writing a simple publisher and subscriber (C++)  
### Beginner: Client libraries: Writing a simple publisher and subscriber (Python)  
### Beginner: Client libraries: Writing a simple service and client (C++)
### Beginner: Client libraries: Writing a simple service and client (Python)
### Beginner: Client libraries: Using parameters in a class (C++)
### Beginner: Client libraries: Using parameters in a class (Python)
###
### Intermediate: Managing Dependencies with rosdep
### Intermediate: Creating an action
### Intermediate: Writing an action server and client (C++)
### Intermediate: Writing an action server and client (Python)
### Intermediate: Composing multiple nodes in a single process
### Intermediate: Launch
###----------------------------------------------------------------------------
### clone source files for the following tutorials 
WORKDIR /home/$USER/
RUN sudo git clone https://github.com/hyeon-gyu/ros2-foxy-tutorial_f1tenth-sim_ws.git 

### move required packages into src
RUN sudo mv ros2-foxy-tutorial_f1tenth-sim_ws/src/* /home/$USER/ros2_ws/src && sudo mv ros2-foxy-tutorial_f1tenth-sim_ws/launch /home/$USER/ros2_ws/src && sudo mv ros2-foxy-tutorial_f1tenth-sim_ws/launch_ws /home/$USER/ros2_ws/src
RUN sudo mv ros2-foxy-tutorial_f1tenth-sim_ws/fibonacci_action_client.py /home/$USER/ros2_ws/ && sudo mv ros2-foxy-tutorial_f1tenth-sim_ws/fibonacci_action_server.py /home/$USER/ros2_ws/
WORKDIR /home/$USER/ros2_ws/src
RUN sudo mv launch launch_mimic

### update package dependencies
WORKDIR /home/$USER/ros2_ws/
RUN rosdep update --include-eol-distros && rosdep install --from-paths src --rosdistro foxy -y --ignore-src

### remove the git clone
RUN sudo rm -rf /home/$USER/ros2-foxy-tutorial_f1tenth-sim_ws

### change the owner of copied files
RUN sudo chown -R $USER:$USER /home/$USER/ros2_ws/

#############################################################
### F1tenth tutorials for foxy distro
#############################################################
### install f1tenth simulator
RUN sudo apt-get update --fix-missing
RUN sudo apt-get install -y git && sudo apt-get install -y nano && sudo apt install -y libeigen3-dev && sudo apt-get install -y tmux && sudo apt-get install -y ros-foxy-rviz2
WORKDIR /home/$USER/
RUN git clone https://github.com/f1tenth/f1tenth_gym
WORKDIR /home/$USER/f1tenth_gym
RUN pip3 install -e .

WORKDIR /home/$USER/
RUN mkdir -p f1t_ws/src
WORKDIR /home/$USER/f1t_ws/src
RUN git clone https://github.com/f1tenth/f1tenth_gym_ros

RUN /bin/bash -c "source /opt/ros/foxy/setup.bash"
WORKDIR /home/$USER/f1t_ws

RUN sudo apt install -y ros-foxy-navigation2 && sudo apt install -y ros-foxy-nav2-bringup && sudo apt install -y ros-foxy-xacro && sudo apt install -y ros-foxy-joint-state-publisher && sudo apt install -y ros-foxy-ackermann-msgs
RUN sudo apt update && sudo apt -y upgrade

### Don't forget to edit by yourself as follows in f1tenth/f1tenth_gym_ros/config/sim.yaml 
### map_path: '/sim_ws/src/f1tenth_gym_ros/maps/levine' ---> '/home/username/f1t_ws/src/f1tenth_gym_ros/maps/levine'

### install f1tenth example code 
WORKDIR /home/$USER/
RUN sudo git clone https://github.com/CL2-UWaterloo/f1tenth_ws.git
RUN sudo mv /home/$USER/f1tenth_ws/src/* /home/$USER/f1t_ws/src

### remove the git clone
WORKDIR /home/$USER/
RUN sudo rm -rf f1tenth_ws

#############################################################
### vesc package && transport_drivers
#############################################################
WORKDIR /home/$USER/f1t_ws/src
RUN sudo git clone https://github.com/f1tenth/vesc.git -b foxy && sudo git clone https://github.com/ros-drivers/transport_drivers.git -b foxy 
WORKDIR /home/$USER/f1t_ws

#remote controller
WORKDIR /home/$USER/
RUN sudo git clone https://github.com/min-kim-oss/f1tenth-controller.git
WORKDIR /home/$USER/f1tenth-controller
RUN sudo mv remocon_server /home/$USER/f1t_ws/src
WORKDIR /home/$USER/
RUN sudo rm -rf f1tenth-controller

#############################################################
### intel realsense camera
#############################################################

#install intel realsense camera driver
WORKDIR /home/$USER/
RUN sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE || sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE
RUN sudo add-apt-repository "deb https://librealsense.intel.com/Debian/apt-repo focal main" -u
RUN sudo apt-get -y install librealsense2-utils && sudo apt-get -y install librealsense2-dev

WORKDIR /home/$USER/f1t_ws/src
RUN sudo git clone --depth 1 --branch `git ls-remote --tags https://github.com/IntelRealSense/realsense-ros.git | grep -Po "(?<=tags/)3.\d+\.\d+" | sort -V | tail -1` https://github.com/IntelRealSense/realsense-ros.git
WORKDIR /home/$USER/f1t_ws
RUN sudo apt-get install python3-rosdep -y
WORKDIR /home/$USER/f1t_ws
RUN sudo apt-get install ros-foxy-diagnostic-updater
RUN rosdep install -i --from-path src --rosdistro $_ros_dist --skip-keys=librealsense2 -y || true
RUN /bin/bash -c "source /opt/ros/foxy/setup.bash"
RUN sudo apt-get -y update && sudo apt-get -y upgrade

#############################################################
### hokuyo lidar
#############################################################
WORKDIR /home/$USER/
WORKDIR /home/$USER/f1t_ws/src
RUN sudo git clone --recursive https://github.com/Hokuyo-aut/urg_node2.git
WORKDIR /home/$USER/f1t_ws/
RUN rosdep update --include-eol-distros && rosdep install -i --from-paths src --rosdistro foxy -y -r
RUN sudo apt-get -y update && sudo apt-get -y upgrade

### change the owner of copied files
RUN sudo chown -R $USER:$USER /home/$USER/f1t_ws

RUN /bin/bash -c "source /opt/ros/foxy/setup.bash"
### done!
WORKDIR /home/$USER
