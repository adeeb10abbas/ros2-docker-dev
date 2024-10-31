#!/bin/bash

## Author: Adeeb Abbas
# This script sets up the ros_dev function in the bashrc file.

# Get the absolute path to the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Define the function
ros_dev() {
  # Check if the correct number of arguments were provided
  if (( $# % 2 != 0 )); then
    echo "Usage: ros_dev <container_name1> <project_path1> [<container_name2> <project_path2> ...]"
    return 1
  fi

  while (( $# >= 2 )); do
    # Set environment variables
    export ROS_DEV_CONTAINER_NAME=$1
    export ROS_PROJECT_PATH=$2
    shift 2

    # Run docker-compose from the correct directory
    cd "$SCRIPT_DIR" && docker-compose up -d --build
  done
}

if [[ $SHELL == "/bin/bash" ]]; then
  shell_config_file="$HOME/.bashrc"
elif [[ $SHELL == "/bin/zsh" ]]; then
  shell_config_file="$HOME/.zshrc"
else
  echo "Unsupported shell"
  exit 1
fi

if ! grep -q "ros_dev ()" "$shell_config_file"; then
  declare -f ros_dev >> "$shell_config_file"
  echo "ros_dev function added to $shell_config_file"
else
  echo "ros_dev function already exists in $shell_config_file"
fi

echo "Done"
