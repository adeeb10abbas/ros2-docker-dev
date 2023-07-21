# ros2-docker-dev

Add the following to your `~/.bashrc` or `~/.zshrc` file to use the `ros_dev` command:

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
    cd $HOME/ros2-docker-dev && docker-compose up -d --build
  done
}

```
If you have multiple workspaces you would like to concurrently build in a single command with corresponding workspaces, use the following - 
```
ros_dev my_ros_container1 /path/to/my/ros/project1 my_ros_container2 /path/to/my/ros/project2
```

This is under active development, so please feel free to contribute to the project. If you have any questions, please open an issue on the GitHub repo. Thanks!

