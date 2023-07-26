# ros2-docker-dev

This Docker-based project for running ROS1/2, including support for visualizations and optional hardware acceleration. Compatibility extends to Focal, Jammy, Mac (Intel and M1), along with support for ROS2 Humble and Noetic. This projects stems out of my own frustration with getting ROS to work on my Macbook Pro M1 and other machines I have had to interact with. I hope this helps you get started with ROS development on your own machine.

 - Works with Ubuntu Focal (20.04), Jammy (22.04) and Macs both Intel and M1. 
 - Currently has support for ROS2 Humble (master branch) and ROS1 Noetic (noetic branch)
 - Can visualize RViz, Gazebo, Intel RealSense Viewer, and other GUIs via VNC or X11 hardware acceleration
 - Supports both Nvidia and Intel Integrated Graphics

Here's a quick preview of ROS2 Humble + RViz on M1 Macbook Pro - 

https://github.com/adeeb10abbas/ros2-docker-dev/assets/38449494/0f008e10-712f-4a6f-a202-ccaeb794a1cd

To make it a super convenient development environment, after running the container. [Just open up VSCode and click on `Attach to a Running Container`](https://code.visualstudio.com/docs/devcontainers/attach-container)

## Installation
Add the following to your `~/.bashrc` or `~/.zshrc` file to use the ros_dev command 
or run the provided `setup.sh` (only for `bash` users). Note - change `$SCRIPT-DIR` to the path of the cloned repo. The `setup.bash` would do this automatically for `bash` users. 
```
ros_dev() {
  # Check if the correct number of arguments were provided
  if (( $# % 2 != 0 )); then
    echo "Usage: ros_dev <container_name1> <project_path1> [<container_name2> <project_path2> ...]"
    return 1
  fi

  while (( $# >= 2 )); do
    # Set environment variables
    ROS_DEV_CONTAINER_NAME=$1
    ROS_PROJECT_PATH=$2
    shift 2

    # Run docker-compose from the correct directory
    cd "$SCRIPT_DIR" && docker-compose up -d --build
  done
}
```
## Usage
To run a single container with your ROS project, use the following:
```
ros_dev my_ros_container /path/to/my/ros/project/src
```

If you have multiple workspaces you would like to concurrently build in a single 
command with corresponding workspaces, use the following:
`ros_dev my_ros_container1 /path/to/my/ros/project1 my_ros_container2 /path/to/my/ros/project2`

The above command will build the container and mount the project directory to 
the container's `/ros2_ws/src directory`. The container will be named my_ros_container 
and will be run in the background. To access the container, use the following: 
`docker exec -it my_ros_container /bin/bash`

To access any desktop visualizations like RViz, go to your local vnc server: 
http://localhost:8080/vnc.html. This should work for essentially all kinds of machines. 
It's much easier to get this working, so I recommend using this method if you're just trying to get something going. 

However, if you have an Nvidia GPU and you have figured out how to install the 
nvidia-docker2 jazz. You can use rocker. You can also use Intel Integrated Graphics  with rocker, however, I haven't tested it. rocker is a tool that allows you to run  docker containers with hardware acceleration. To use rocker, with our containers run the following:
`rocker --nvidia --x11 -- my_ros_container`

This is under active development, so please feel free to contribute to the project. 
If you have any questions, please open an issue on the GitHub repo. Thanks!
