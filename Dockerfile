# Selenium + Selenese.
FROM selenium/standalone-chrome:latest

LABEL maintainer "Michael Molchanov <mmolchanov@adyax.com>"

USER root

# SSH config.
RUN mkdir -p /root/.ssh
ADD config/ssh /root/.ssh/config
RUN chown root:root /root/.ssh/config && chmod 600 /root/.ssh/config

RUN apt-get update -qqy \
  && apt-get -qqy --no-install-recommends install software-properties-common libgconf-2-4 curl wget unzip openssh-client rsync gettext-base python python-pip python-setuptools python-wheel python-dev python3 python3-pip python3-setuptools python3-wheel python3-dev build-essential libssl-dev libffi-dev \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

ENV ALLURE_HOME /usr
# See http://repo.maven.apache.org/maven2/io/qameta/allure/allure-commandline/
ENV ALLURE_VERSION 2.12.1
RUN curl -o allure-commandline-${ALLURE_VERSION}.tgz -Ls http://repo.maven.apache.org/maven2/io/qameta/allure/allure-commandline/${ALLURE_VERSION}/allure-commandline-${ALLURE_VERSION}.tgz \
  && tar -zxvf allure-commandline-${ALLURE_VERSION}.tgz -C /opt/ \
  && ln -s /opt/allure-${ALLURE_VERSION}/bin/allure /usr/bin/allure \
  && allure --version


COPY entry_point.sh /opt/bin/entry_point.sh
RUN chmod +x /opt/bin/entry_point.sh

