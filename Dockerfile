# Use the official ROS image as the base image
FROM ros:humble-ros-core-jammy

# install bootstrap tools
RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    git \
    python3-colcon-common-extensions \
    python3-colcon-mixin \
    python3-rosdep \
    python3-vcstool \
    && rm -rf /var/lib/apt/lists/*

# bootstrap rosdep
RUN rosdep init && \
  rosdep update --rosdistro $ROS_DISTRO

# setup colcon mixin and metadata
RUN colcon mixin add default \
      https://raw.githubusercontent.com/colcon/colcon-mixin-repository/master/index.yaml && \
    colcon mixin update && \
    colcon metadata add default \
      https://raw.githubusercontent.com/colcon/colcon-metadata-repository/master/index.yaml && \
    colcon metadata update

RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-humble-desktop=0.10.0-1* \
    && rm -rf /var/lib/apt/lists/*

SHELL ["/bin/bash", "-c"]

# Install necessary tools for X11 forwarding
RUN apt-get update && apt-get install -y --no-install-recommends \
    xauth \
    x11-apps \
    x11-utils \
    x11-xserver-utils \
    && rm -rf /var/lib/apt/lists/*
RUN apt-get upgrade 
# Install Rviz and other necessary packages
ENV DISPLAY :0

# Run Rviz
RUN echo "export DISABLE_AUTO_TITLE=true" >> /root/.bashrc
RUN echo 'LC_NUMERIC="en_US.UTF-8"' >> /root/.bashrc
RUN echo "source /opt/ros/humble/setup.zsh" >> /root/.bashrc
RUN echo "source /usr/share/gazebo/setup.sh" >> /root/.bashrc

RUN echo 'alias rosdi="rosdep install --from-paths src --ignore-src --rosdistro=${ROS_DISTRO} -y"' >> /root/.bashrc
RUN echo 'alias cbuild="colcon build --symlink-install"' >> /root/.bashrc
RUN echo 'alias ssetup="source ./install/local_setup.zsh"' >> /root/.bashrc
RUN echo 'alias cyclone="export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp"' >> /root/.bashrc
RUN echo 'alias fastdds="export RMW_IMPLEMENTATION=rmw_fastrtps_cpp"' >> /root/.bashrc
RUN echo "autoload -U bashcompinit" >> /root/.bashrc
RUN echo "bashcompinit" >> /root/.bashrc
RUN echo 'eval "$(register-python-argcomplete3 ros2)"' >> /root/.bashrc
RUN echo 'eval "$(register-python-argcomplete3 colcon)"' >> /root/.bashrc
RUN source ~/.bashrc
CMD ["rviz2"]

