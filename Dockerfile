# Description: Build environment for Cyclone V SoC embedded applications
# Author: David Blyth
# Acknowledgements: This container is based on work found in
# https://github.com/chriz2600/quartus-lite and
# https://github.com/machinaut/quartus-docker

#FROM ubuntu:18.04
# 20.04 seems not permitting the installation of one of:
#libwebkit-1.0.so.2
#libwebkitgtk-3.0.so.0
#libwebkitgtk-1.0.so.0
FROM ubuntu:20.04

WORKDIR /root

RUN export DEBIAN_FRONTEND=noninteractive \
&&  apt-get update > /dev/null \
&&  apt-get -y -qq install wget > /dev/null \
&&  rm -rf /var/lib/apt/lists/*

# Install Quartus Lite and Cyclone V files
RUN wget -q http://download.altera.com/akdlm/software/acdsinst/20.1std/711/ib_installers/cyclonev-20.1.0.711.qdz \
&&  wget -q -O quartus-lite.run http://download.altera.com/akdlm/software/acdsinst/20.1std/711/ib_installers/QuartusLiteSetup-20.1.0.711-linux.run \
&&  chmod +x quartus-lite.run \
&&  ./quartus-lite.run --mode unattended --installdir /opt/intelFPGA/20.1 --accept_eula yes \
&&  rm -rf *

# Set the locale
RUN export DEBIAN_FRONTEND=noninteractive \
&&  apt-get update > /dev/null \
&&  apt-get -y -qq install locales > /dev/null \
&&  rm -rf /var/lib/apt/lists/*

RUN locale-gen en_US.UTF-8  
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

WORKDIR /mnt