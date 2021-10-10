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
#FROM ubuntu:20.04

FROM dorowu/ubuntu-desktop-lxde-vnc:bionic

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

# Install SoC EDS
RUN wget -q -O soc-eds.run http://download.altera.com/akdlm/software/acdsinst/20.1std/711/ib_installers/SoCEDSSetup-20.1.0.711-linux.run \
&&  chmod +x soc-eds.run \
&&  ./soc-eds.run --mode unattended --installdir /opt/intelFPGA/20.1 --accept_eula yes \
&&  rm -rf *

# Install DS-5 pre-requisites
RUN export DEBIAN_FRONTEND=noninteractive \
&&  apt-get update > /dev/null \
&&  ln -fs /usr/share/zoneinfo/Europe/Rome /etc/localtime > /dev/null \
&&  apt-get install -y tzdata > /dev/null \
&&  dpkg-reconfigure --frontend noninteractive tzdata > /dev/null \
&&  apt-get -y -qq install libwebkit2gtk-4.0-37 > /dev/null \
&&  rm -rf /var/lib/apt/lists/*

# Install DS-5
RUN wget -q https://download.altera.com/akdlm/software/armds/2021.1/linux64/DS000-BN-00001-r21p1-00rel0.tgz \
&&  tar -xf DS000-BN-00001-r21p1-00rel0.tgz \
&&  cd DS000-BN-00001-r21p1-00rel0 \
&&  ./armds-2021.1.sh --no-interactive -d/opt/arm/developmentstudio-2021.1 --i-agree-to-the-contained-eula \
&& rm -rf *

# Set the locale
RUN export DEBIAN_FRONTEND=noninteractive \
&&  apt-get update > /dev/null \
&&  apt-get -y -qq install locales > /dev/null \
&&  rm -rf /var/lib/apt/lists/*

RUN locale-gen en_US.UTF-8  
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

# Other required tools and libraries
RUN export DEBIAN_FRONTEND=noninteractive \
&&  apt-get update > /dev/null \
&&  apt-get -y -qq install gcc u-boot-tools device-tree-compiler build-essential > /dev/null \
&&  rm -rf /var/lib/apt/lists/*

# Install compiler
RUN wget https://developer.arm.com/-/media/Files/downloads/gnu-a/10.3-2021.07/binrel/gcc-arm-10.3-2021.07-x86_64-arm-none-linux-gnueabihf.tar.asc \
&& tar -xf gcc-arm-10.3-2021.07-x86_64-arm-none-linux-gnueabihf.tar.asc \
&& rm -Rf gcc-arm-10.3-2021.07-x86_64-arm-none-linux-gnueabihf.tar.asc \
&& cd /root/gcc-arm-10.3-2021.07-x86_64-arm-none-linux-gnueabihf/bin \
&& ln -s arm-none-linux-gnueabihf-g++ arm-linux-gnueabihf-g++
ENV PATH="/root/gcc-arm-10.3-2021.07-x86_64-arm-none-linux-gnueabihf/bin:${PATH}"

# Set default behavior
WORKDIR /opt/intelFPGA/20.1/embedded
CMD bash embedded_command_shell.sh

#WORKDIR /mnt