FROM openjdk:8

# Install Git and dependencies
RUN dpkg --add-architecture i386 \
 && apt-get update \
 && apt-get install -y file git curl ssh rsync zip libncurses5:i386 libstdc++6:i386 zlib1g:i386 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists /var/cache/apt

ENV ANDROID_HOME="/home/user/android-sdk-linux" \
    SDK_URL="https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip" \
    ANDROID_BUILD_TOOLS_VERSION=28.0.2 \
    ANDROID_PLATFORM_VERSION=android-28

# Create a non-root user
RUN useradd -m user
USER user
WORKDIR /home/user

# Download Android SDK
RUN mkdir "$ANDROID_HOME" .android \
 && cd "$ANDROID_HOME" \
 && curl -o sdk.zip $SDK_URL \
 && unzip sdk.zip \
 && rm sdk.zip \
 && yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses \
 && mkdir -p ~/.android \
 && touch ~/.android/repositories.cfg

ENV PATH="${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${PATH}"

# Install build tools
RUN echo y | sdkmanager "platform-tools" \
 && echo y | sdkmanager "build-tools;$ANDROID_BUILD_TOOLS_VERSION" \
 && echo y | sdkmanager "platforms;$ANDROID_PLATFORM_VERSION"

ENV PATH="${ANDROID_HOME}/platform-tools:${PATH}"
