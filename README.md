# Usage
## build (optional)
The prebuilt container is hosted on Docker Hub.  If you wish to build it yourself, use the following command.
```shell
docker build -t bozzochet/cyclonev-soc-eds .
```

## run container and mount current directory
```shell
docker run -it --rm -v $PWD:/mnt bozzochet/cyclonev-soc-eds
```
The above command puts you into the SoC EDS embedded command shell.
