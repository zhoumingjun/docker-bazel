FROM debian:jessie

MAINTAINER zhoumingjun <zhoumingjun@gmail.com>

# Accecpt Oracle license before installing java
RUN echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
RUN echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections

# update repos
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
RUN apt-get update && apt-get install -y \
    autoconf \
    automake \
    bison \
    build-essential \
    flex \
    g++ \
    git \
    golang \
    libarchive-dev \
    libboost-dev \
    libboost-test-dev \
    libevent-dev \
    libgflags-dev \
    libgoogle-glog-dev \
    liblua5.2-dev \
    libluajit-5.1-dev \
    libssl-dev \
    libtool \
    libunwind8-dev \
    lua5.2 \
    luajit \
    oracle-java8-installer \
    oracle-java8-set-default \
    pkg-config \
    zip \
    zlib1g-dev

RUN apt-get clean

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# compile bazel
RUN git clone https://github.com/google/bazel.git /opt/bazel && \
    /opt/bazel/compile.sh

#add bazel
ENV PATH $PATH:/opt/bazel/output/

RUN cd /opt/bazel && \
    bazel build //scripts:bazel-complete.bash && \
    cp bazel-bin/scripts/bazel-complete.bash /etc/bash_completion.d
