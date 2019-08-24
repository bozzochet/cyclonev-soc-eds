# Description: Build environment for Cyclone V SoC embedded applications
# Author: David Blyth
# Acknowledgements: This container is based on work found in
# https://github.com/chriz2600/quartus-lite and
# https://github.com/machinaut/quartus-docker

FROM ubuntu:18.04

WORKDIR /root

RUN apt-get update \
        > /dev/null \
&&  apt-get -y -qq install \
        wget \
        > /dev/null \
&&  rm -rf /var/lib/apt/lists/*

# Install Quartus Lite and Cyclone V files
RUN wget -q \
        http://download.altera.com/akdlm/software/acdsinst/18.1std/625/ib_installers/cyclonev-18.1.0.625.qdz \
&&  wget -q -O quartus-lite.run \
        http://download.altera.com/akdlm/software/acdsinst/18.1std/625/ib_installers/QuartusLiteSetup-18.1.0.625-linux.run \
&&  chmod +x quartus-lite.run \
&&  ./quartus-lite.run \
        --mode unattended \
        --installdir /opt/intelFPGA/18.1 \
        --accept_eula yes \
&&  rm -rf *

# Install SoC EDS
RUN wget -q -O soc-eds.run \
        http://download.altera.com/akdlm/software/acdsinst/18.1std/625/ib_installers/SoCEDSSetup-18.1.0.625-linux.run \
&&  chmod +x soc-eds.run \
&&  ./soc-eds.run \
        --mode unattended \
        --installdir /opt/intelFPGA/18.1 \
        --accept_eula yes \
&&  rm -rf *

# Install DS-5
RUN dpkg --add-architecture i386 \
&&  apt-get update \
        > /dev/null \
&&  apt-get -y -qq install \
        libasound2 \
        libatk1.0-0 \
        libcairo2 \
        libglu1-mesa \
        libgtk2.0-0 \
        libxt6 \
        libxtst6 \
        libc6:i386 \
        libstdc++6:i386 \
        libz1:i386 \
        libwebkitgtk-3.0-0 \
        > /dev/null \
&&  rm -rf /var/lib/apt/lists/*

RUN cd /opt/intelFPGA/18.1/embedded/ds-5_installer \
&&  ./install.sh \
        --i-agree-to-the-contained-eula \
        --no-interactive \
        -d /opt/intelFPGA/18.1/embedded/ds-5

# Set the locale
RUN apt-get update \
        > /dev/null \
&&  apt-get -y -qq install \
        locales \
        > /dev/null \
&&  rm -rf /var/lib/apt/lists/*

RUN locale-gen en_US.UTF-8  
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

# Resolve malloc() issues
RUN apt-get update \
        > /dev/null \
&&  apt-get -y -qq install \
        libtcmalloc-minimal4 \
        > /dev/null \
&&  rm -rf /var/lib/apt/lists/*

ENV LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libtcmalloc_minimal.so.4

RUN cp /usr/lib/x86_64-linux-gnu/libstdc++.so.6 \
        /opt/intelFPGA/18.1/quartus/linux64/

# Other required tools and libraries
RUN apt-get update \
        > /dev/null \
&&  apt-get -y -qq install \
        gcc \
        u-boot-tools \
        device-tree-compiler \
        > /dev/null \
&&  rm -rf /var/lib/apt/lists/*

RUN wget -q -O libpng12.deb \
        http://security.ubuntu.com/ubuntu/pool/main/libp/libpng/libpng12-0_1.2.54-1ubuntu1.1_amd64.deb \
&&  apt-get -y -qq install \
        ./libpng12.deb \
        > /dev/null \
&&  rm -rf *

# Set default behavior
WORKDIR /opt/intelFPGA/18.1/embedded

CMD bash embedded_command_shell.sh
