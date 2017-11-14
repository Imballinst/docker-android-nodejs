FROM nao20010128nao/android-build:latest

LABEL maintainer="Try Ajitiono <ballinst@gmail.com>"

ARG NODEJS_VERSION=6.11.3
ARG ANDROID_NDK_VERSION=10e
ARG ANDROID_NDK_HOME=/opt/android-ndk

ENV ANDROID_NDK=${ANDROID_NDK_HOME}/android-ndk-r${ANDROID_NDK_VERSION}
ENV ANDROID_SDK=/opt/android-sdk-linux

ENV PATH=$PATH:${ANDROID_NDK}:/opt/node/bin

RUN set -x && apt-get update -qq && apt upgrade -y -qq && apt-get clean && rm -rf /var/lib/apt/lists/* && \
    
    mkdir /opt/android-ndk && \
    mkdir /opt/android-ndk-tmp && \
    cd /opt/android-ndk-tmp && wget -q https://dl.google.com/android/repository/android-ndk-r${ANDROID_NDK_VERSION}-linux-x86_64.zip && \
    unzip -q android-ndk-r${ANDROID_NDK_VERSION}-linux-x86_64.zip && mv ./android-ndk-r${ANDROID_NDK_VERSION} ${ANDROID_NDK_HOME} && \
    rm -rf /opt/android-ndk-tmp

WORKDIR "/opt/node"

RUN apt-get update && apt-get install -y curl ca-certificates file build-essential --no-install-recommends && \
    curl -sL https://nodejs.org/dist/v${NODEJS_VERSION}/node-v${NODEJS_VERSION}-linux-x64.tar.gz | tar xz --strip-components=1 && \
    apt-get install -y git && \
    rm -rf /var/lib/apt/lists/* && \
    npm install npm -g && \
    npm install -g react-native-cli && \
    apt-get clean
