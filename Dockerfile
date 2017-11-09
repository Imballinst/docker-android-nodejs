FROM nao20010128nao/android-build:latest

MAINTAINER Or Yagel <or@soluto.com>

ARG ANDROID_NDK_VERSION=10e
ARG ANDROID_CMAKE_VERSION=3.6.3155560

ENV NODEJS_VERSION=6.11.3
ENV ANDROID_NDK_HOME=/opt/android-ndk
ENV ANDROID_NDK=/opt/android-ndk/android-ndk-r${ANDROID_NDK_VERSION}
ENV PATH=$PATH:${ANDROID_NDK}:/opt/node/bin

RUN set -x && apt-get update -qq && apt upgrade -y -qq && apt-get clean && rm -rf /var/lib/apt/lists/* && \
    
    mkdir /opt/android-ndk && \
    mkdir /opt/android-ndk-tmp && \
    cd /opt/android-ndk-tmp && wget -q https://dl.google.com/android/repository/android-ndk-r${ANDROID_NDK_VERSION}-linux-x86_64.zip && \
    unzip -q android-ndk-r${ANDROID_NDK_VERSION}-linux-x86_64.zip && mv ./android-ndk-r${ANDROID_NDK_VERSION} ${ANDROID_NDK_HOME} && \
    rm -rf /opt/android-ndk-tmp && \

    mkdir /opt/android-cmake-tmp && \
    cd /opt/android-cmake-tmp && wget -q https://dl.google.com/android/repository/cmake-${ANDROID_CMAKE_VERSION}-linux-x86_64.zip -O android-cmake.zip && \
    unzip -q android-cmake.zip -d android-cmake && mv ./android-cmake ${ANDROID_HOME}/cmake && \
    rm -rf /opt/android-cmake-tmp

WORKDIR "/opt/node"

RUN apt-get install -y curl ca-certificates --no-install-recommends && \
    curl -sL https://nodejs.org/dist/v${NODEJS_VERSION}/node-v${NODEJS_VERSION}-linux-x64.tar.gz | tar xz --strip-components=1 && \
    apt-get install -y git && \
    rm -rf /var/lib/apt/lists/* && \
    npm install npm -g && \
    npm install -g react-native-cli && \
    apt-get clean
