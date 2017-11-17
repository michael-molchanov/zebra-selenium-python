# Selenium + Selenese.
FROM selenium/standalone-firefox:latest

LABEL maintainer "Michael Molchanov <mmolchanov@adyax.com>"

USER root

RUN apt-get update -qqy \
  && apt-get -qqy --no-install-recommends install software-properties-common gettext-base python python-pip python-setuptools \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

RUN apt-add-repository ppa:qameta/allure \
  && apt-get update \
  && apt-get install allure \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

COPY entry_point.sh /opt/bin/entry_point.sh
RUN chmod +x /opt/bin/entry_point.sh

