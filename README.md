# android-emulator-docker
Dockerfile for Ubuntu + Java8 + Android SDK + Android System Image

### Currently installed Android 7.1.1 and latest on Feb 2019 but you can parametrize for your needs, e.g.:

```
docker build --build-arg ANDROID_PLATFORM_VERSION=android-27 .
```

### See configurable args in the Dockerfile itself:

```
ARG SDK_VERSION=sdk-tools-linux-4333796
ARG ANDROID_BUILD_TOOLS_VERSION=28.0.3
ARG ANDROID_PLATFORM_VERSION=android-25
ARG SYS_IMG=x86
ARG IMG_TYPE=google_apis
```