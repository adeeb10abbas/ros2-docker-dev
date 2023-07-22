# Adds the following function to the bashrc file:

echo "Adding ros_dev function to bashrc file"

echo 'ros_dev() {
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
' >> $HOME/.bashrc

echo "Done"
