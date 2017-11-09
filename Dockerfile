FROM nao20010128nao/android-build:latest

MAINTAINER Or Yagel <or@soluto.com>

ENV NODEJS_VERSION=6.11.3 \
    ENV ANDROID_NDK=/opt/android-ndk \
    PATH=$PATH:${ANDROID_NDK}:/opt/node/bin

WORKDIR "/opt/node"

RUN npm install -g react-native-cli && \
    apt-get update && apt-get install -y curl ca-certificates --no-install-recommends && \
    curl -sL https://nodejs.org/dist/v${NODEJS_VERSION}/node-v${NODEJS_VERSION}-linux-x64.tar.gz | tar xz --strip-components=1 && \
    apt-get install -y git && \
    rm -rf /var/lib/apt/lists/* && \
    npm install npm -g && \
    apt-get clean
