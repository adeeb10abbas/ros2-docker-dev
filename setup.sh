## Author: Adeeb Abbas
# This script sets up the ros_dev function in the bashrc file.

# Get the absolute path to the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Adds the following function to the bashrc file:

if [[ $SHELL == "/bin/bash" ]]; then
    # Check if the function already exists in the bashrc file
    if ! grep -q "ros_dev()" "$HOME/.bashrc"; then
        echo 'ros_dev() {
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
        }' >> "$HOME/.bashrc"
        echo "ros_dev function added to bashrc file"
    else
        echo "ros_dev function already exists in bashrc file"
    fi
else if [[ $SHELL == "/bin/zsh" ]]; then
    # Check if the function already exists in the zshrc file
    if ! grep -q "ros_dev()" "$HOME/.zshrc"; then
        echo 'ros_dev() {
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
        }' >> "$HOME/.zshrc"
        echo "ros_dev function added to zshrc file"
    else
        echo "ros_dev function already exists in zshrc file"
    fi
 else
    echo "Unsupported shell"
    exit 1
  fi
fi
echo "Done"
