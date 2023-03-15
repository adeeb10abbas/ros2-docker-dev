# rviz2-docker-mac

To build the image, save the Dockerfile and run the following command in the same directory:

`docker build -t ros-mac .`

To run the container with X11 forwarding, first install XQuartz on your M1 Mac:
`brew install xquartz`

Launch XQuartz, and enable "Allow connections from network clients" in the Preferences > Security settings. Restart XQuartz for the changes to take effect.

Now, get your local IP address and allow XQuartz to accept connections from it:

```
ip=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')
xhost + $ip
```
Finally, run the Docker container with the necessary flags:
```
docker run -it --rm -e DISPLAY=$ip:0 -v /tmp/.X11-unix:/tmp/.X11-unix --privileged ros-mac
```
Please note that running the container with --privileged can expose your system to security risks. Use this flag only if you understand the implications and trust the container you're running.

This is under active development, so please feel free to contribute to the project. If you have any questions, please open an issue on the GitHub repo. Thanks!

