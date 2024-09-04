# Mitsuba Docker

This builds the CUDA version of Mitsuba 3 inside docker.

First, install Docker and the [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html).

Then, build the image and run
```bash
docker build -t mitsuba3 .
docker build -t mitsuba3-dev dev/ # Optionally
docker run -it --runtime=nvidia \
    --gpus all \
    -e NVIDIA_DRIVER_CAPABILITIES=graphics,compute,utility \
    --name mitsuba3 \
    mitsuba3
```
