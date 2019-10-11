# Selenium + Selenese.
FROM selenium/standalone-firefox:latest

LABEL maintainer "Michael Molchanov <mmolchanov@adyax.com>"

USER root

# SSH config.
RUN mkdir -p /root/.ssh
ADD config/ssh /root/.ssh/config
RUN chown root:root /root/.ssh/config && chmod 600 /root/.ssh/config

RUN apt-get update \
  && apt-get -y install \
  software-properties-common \
  language-pack-en-base \
  libgconf-2-4 \
  bash \
  build-essential \
  git-core \
  curl \
  jq \
  wget \
  unzip \
  openssl \
  procps \
  openssh-client \
  rsync \
  gettext-base \
  python \
  python-pip \
  python-setuptools \
  python-wheel \
  python-dev \
  python3 \
  python3-pip \
  python3-setuptools \
  python3-wheel \
  python3-dev \
  libssl-dev \
  libffi-dev \
  && locale-gen en_US.UTF-8 \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/* \
  && pip install yq requests

ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8

COPY --from=hairyhenderson/gomplate:v3.1.0-slim /gomplate /bin/gomplate

# Install goofys
ENV GOOFYS_VERSION 0.19.0
RUN curl --fail -sSL -o goofys https://github.com/kahing/goofys/releases/download/v${GOOFYS_VERSION}/goofys \
  && mv goofys /usr/local/bin/ \
  && chmod +x /usr/local/bin/goofys

# Install fd
ENV FD_VERSION 7.3.0
RUN curl --fail -sSL -o fd.tar.gz https://github.com/sharkdp/fd/releases/download/v${FD_VERSION}/fd-v${FD_VERSION}-x86_64-unknown-linux-gnu.tar.gz \
  && tar -zxf fd.tar.gz \
  && cp fd-v${FD_VERSION}-x86_64-unknown-linux-gnu/fd /usr/local/bin/ \
  && rm -f fd.tar.gz \
  && rm -fR fd-v${FD_VERSION}-x86_64-unknown-linux-gnu \
  && chmod +x /usr/local/bin/fd

# Install variant
ENV VARIANT_VERSION 0.36.4
RUN curl --fail -sSL -o variant.tar.gz https://github.com/mumoshu/variant/releases/download/v${VARIANT_VERSION}/variant_${VARIANT_VERSION}_linux_amd64.tar.gz \
    && mkdir -p variant \
    && tar -zxf variant.tar.gz -C variant \
    && cp variant/variant /usr/local/bin/ \
    && rm -f variant.tar.gz \
    && rm -fR variant \
    && chmod +x /usr/local/bin/variant

ENV ALLURE_HOME /usr
# See http://repo.maven.apache.org/maven2/io/qameta/allure/allure-commandline/
ENV ALLURE_VERSION 2.12.1
RUN curl -o allure-commandline-${ALLURE_VERSION}.tgz -Ls http://repo.maven.apache.org/maven2/io/qameta/allure/allure-commandline/${ALLURE_VERSION}/allure-commandline-${ALLURE_VERSION}.tgz \
  && tar -zxvf allure-commandline-${ALLURE_VERSION}.tgz -C /opt/ \
  && ln -s /opt/allure-${ALLURE_VERSION}/bin/allure /usr/bin/allure \
  && allure --version

