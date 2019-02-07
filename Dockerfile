FROM ubuntu:latest

WORKDIR /root

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -qqy update && \
    apt-get -qqy --no-install-recommends install \
    openjdk-8-jdk \
    ca-certificates \
    tzdata \
    zip \
    unzip \
    curl \
    wget \
    libqt5webkit5 \
    libgconf-2-4 \
    xvfb \
    gnupg \
  && rm -rf /var/lib/apt/lists/*

# Set JAVA_HOME
ENV JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64/jre" \
    PATH=$PATH:$JAVA_HOME/bin

# Install Android SDK
ARG SDK_VERSION=sdk-tools-linux-4333796
ARG ANDROID_BUILD_TOOLS_VERSION=28.0.3
ARG ANDROID_PLATFORM_VERSION=android-25
ARG SYS_IMG=x86
ARG IMG_TYPE=google_apis

ENV SDK_VERSION=$SDK_VERSION \
    ANDROID_BUILD_TOOLS_VERSION=$ANDROID_BUILD_TOOLS_VERSION \
    ANDROID_HOME=/usr/local/android-sdk \
    API_LEVEL=$API_LEVEL \
    PROCESSOR=$PROCESSOR \
    SYS_IMG=$SYS_IMG \
    IMG_TYPE=$IMG_TYPE

RUN wget -O tools.zip https://dl.google.com/android/repository/${SDK_VERSION}.zip && \
    unzip tools.zip -d $ANDROID_HOME && rm tools.zip && \
    chmod a+x -R $ANDROID_HOME && \
    chown -R root:root $ANDROID_HOME

ENV PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools

# https://askubuntu.com/questions/885658/android-sdk-repositories-cfg-could-not-be-loaded
RUN mkdir -p ~/.android && \
    touch ~/.android/repositories.cfg && \
    echo yes | sdkmanager --licenses && \
    echo y | sdkmanager "platform-tools" && \
    echo y | sdkmanager "build-tools;$ANDROID_BUILD_TOOLS_VERSION" && \
    echo y | sdkmanager "platforms;$ANDROID_PLATFORM_VERSION" && \
    echo y | sdkmanager "system-images;$ANDROID_PLATFORM_VERSION;$IMG_TYPE;$SYS_IMG" "emulator"

# Install VNC
RUN apt-get -qqy update && apt-get -qqy install --no-install-recommends \
    xterm \
    supervisor \
    socat \
    x11vnc \
    openbox \
    menu \
    python-numpy \
    net-tools \
    ffmpeg \
    jq \
    qemu-kvm \
    libvirt-bin \
    ubuntu-vm-builder \
    bridge-utils \
 && rm -rf /var/lib/apt/lists/*

 RUN  wget -nv -O noVNC.zip "https://github.com/novnc/noVNC/archive/master.zip" \
  && unzip -x noVNC.zip \
  && rm noVNC.zip  \
  && mv noVNC-master noVNC \
  && wget -nv -O websockify.zip "https://github.com/novnc/websockify/archive/master.zip" \
  && unzip -x websockify.zip \
  && mv websockify-master ./noVNC/utils/websockify \
  && rm websockify.zip \
  && ln ./noVNC/vnc_lite.html noVNC/index.html

 # Expose VNC port
 EXPOSE 6080 5900

 ADD container /root

 RUN chmod +x supervisord.conf && \
     chmod +x entrypoint.sh

 ENTRYPOINT /root/entrypoint.sh

 CMD /usr/bin/supervisord -c /root/supervisord.conf