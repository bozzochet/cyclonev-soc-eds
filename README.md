# Usage
## build (optional)
The prebuilt container is hosted on Docker Hub.  If you wish to build it yourself, use the following command.
```shell
docker build -t rditech/cyclonev-soc-eds .
```

## run container and mount current directory
```shell
docker run -it --rm -v $PWD:/mnt rditech/cyclonev-soc-eds
```
The above command puts you into the SoC EDS embedded command shell.
