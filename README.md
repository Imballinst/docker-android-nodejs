## docker-android-react-native
This repository uses [nao20010128nao's Docker repository](https://hub.docker.com/r/nao20010128nao/android-build/tags/) with the tag `latest` and extends the features of [sumartoyo's repository](https://github.com/sumartoyo/docker-android-nodejs).

### Docker Repository
https://hub.docker.com/r/imballinst/docker-android-react-native/

### Features
1. NodeJS
2. Android SDK
3. Android NDK

### Code Explanation
```
FROM nao20010128nao/android-build:latest
```
Uses the box with the tag `latest` from the given repository.
```
LABEL maintainer="Try Ajitiono <ballinst@gmail.com>"
```
I used the syntax `MAINTAINER <name/email>` until I read [the doc](https://docs.docker.com/engine/reference/builder/#maintainer-deprecated) about the deprecation of `MAINTAINER` syntax. So, I'm using `LABEL` now.
```
ARG NODEJS_VERSION=6.11.3
ARG ANDROID_NDK_VERSION=10e

ENV ANDROID_NDK=/opt/android-ndk/android-ndk-r${ANDROID_NDK_VERSION}
ENV ANDROID_SDK=/opt/android-sdk-linux

ENV PATH=$PATH:${ANDROID_NDK}:/opt/node/bin
```
Sets environments (`ENV`) and arguments (`ARG`). I use `ARG` for NodeJS and Android NDK version because they are irrelevant to be environment variables-- while Android SDK and NDK path are used during the gradle building process (if you don't define them, you will face some kind of `Not Found` error later.
```
RUN set -x && apt-get update -qq && apt upgrade -y -qq && apt-get clean && rm -rf /var/lib/apt/lists/* && \
    
    mkdir /opt/android-ndk && \
    mkdir /opt/android-ndk-tmp && \
    cd /opt/android-ndk-tmp && wget -q https://dl.google.com/android/repository/android-ndk-r${ANDROID_NDK_VERSION}-linux-x86_64.zip && \
    unzip -q android-ndk-r${ANDROID_NDK_VERSION}-linux-x86_64.zip && mv ./android-ndk-r${ANDROID_NDK_VERSION} ${ANDROID_NDK_HOME} && \
    rm -rf /opt/android-ndk-tmp
```
Creates temporary directory to contain the downloaded Android NDK ZIP file. Then, it (the ZIP) will be extracted inside that folder, yielding folder `android-ndk-10e`, and then it will be moved to `/opt/android-ndk`, so `ANDROID_NDK` environment path will match the real one `/opt/android-ndk/android-ndk-10e`.
```
WORKDIR "/opt/node"

RUN apt-get update && apt-get install -y curl ca-certificates file build-essential --no-install-recommends && \
    curl -sL https://nodejs.org/dist/v${NODEJS_VERSION}/node-v${NODEJS_VERSION}-linux-x64.tar.gz | tar xz --strip-components=1 && \
    apt-get install -y git && \
    rm -rf /var/lib/apt/lists/* && \
    npm install npm -g && \
    npm install -g react-native-cli && \
    apt-get clean
```
Changes directory to `/opt/node` and installs stuffs. `curl` and `ca-certificates` for the download tool, `file` and `build-essential` are basically used for the building process, where `file` and `make` executables are needed.

### License
MIT