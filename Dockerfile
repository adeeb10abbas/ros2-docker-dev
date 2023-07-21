# Use the official ROS image as the base image
FROM ros:humble-ros-core-jammy

# Set shell for running commands
SHELL ["/bin/bash", "-c"]

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

# Bazel Installer only needed for arm64 systems
RUN install_bazel() { \
    wget "https://github.com/bazelbuild/bazel/releases/download/6.2.0/bazel-6.2.0-linux-$1" && \
    chmod 755 bazel-6.2.0-linux-$1 && \
    mv bazel-6.2.0-linux-$1 /usr/bin/bazel; \
}

# Install Bazel for arm64 systems since install_prereqs.sh doesn't for non x86_64 systems
RUN if [ "$ARCH" = "arm64" ] ; then \
        install_bazel "arm64" \
    ; fi

# Set the entrypoint to source ROS setup.bash and run a bash shell
CMD [ "source /opt/ros/humble/setup.bash", "/bin/bash"]
