FROM ubuntu:xenial

LABEL maintainer="Try Ajitiono <ballinst@gmail.com>"

# Set arguments
ARG NODEJS_VERSION=8.11.2
ARG GRADLE_VERSION=4.7
ARG ANDROID_NDK_VERSION=10e
ARG ANDROID_NDK_HOME=/opt/android-ndk

# Set environment
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Set paths
ENV GRADLE_BIN_PATH=/opt/gradle/bin PATH=${PATH}:/opt/gradle/bin
ENV ANDROID_NDK=${ANDROID_NDK_HOME}/android-ndk-r${ANDROID_NDK_VERSION}
ENV ANDROID_SDK=/opt/android-sdk-linux

ENV PATH=$PATH:${ANDROID_NDK}:/opt/node/bin

# Install OpenJDK
RUN set -xe && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y locales openjdk-8-jdk git tree zip unzip p7zip p7zip-full curl wget && \
    rm -rf /var/lib/apt/lists/* && \
    locale-gen en_US.UTF-8

# Install Gradle
RUN cd /opt && wget --output-document=gradle.zip https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip && \
    unzip gradle.zip && \
    rm gradle.zip && \
mv gradle-${GRADLE_VERSION} /opt/gradle

WORKDIR "/opt/node"

# Install basic dependencies
RUN apt-get update && apt-get install -y curl ca-certificates file build-essential --no-install-recommends && \
    # Install Android NDK
    mkdir /opt/android-ndk && \
    mkdir /opt/android-ndk-tmp && \
    cd /opt/android-ndk-tmp && wget -q https://dl.google.com/android/repository/android-ndk-r${ANDROID_NDK_VERSION}-linux-x86_64.zip && \
    unzip -q android-ndk-r${ANDROID_NDK_VERSION}-linux-x86_64.zip && mv ./android-ndk-r${ANDROID_NDK_VERSION} ${ANDROID_NDK_HOME} && \
    rm -rf /opt/android-ndk-tmp

# Install Node, NPM, and React-Native CLI
RUN curl -sL https://nodejs.org/dist/v${NODEJS_VERSION}/node-v${NODEJS_VERSION}-linux-x64.tar.gz | tar xz --strip-components=1 && \
    apt-get install -y git && \
    rm -rf /var/lib/apt/lists/* && \
    npm install npm -g && \
    npm install react-native-cli -g && \
    apt-get clean
