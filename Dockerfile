FROM ubuntu:16.04
MAINTAINER Yasushi Kobayashi <ptpadan@gmail.com>

RUN apt-get update && \
  apt-get install -y curl wget git unzip build-essential gcc zlib1g-dev libssl-dev

# setup nodejs
ENV NODE_V=v8.1.0
ENV PATH=/usr/local/node-${NODE_V}-linux-x64/bin:$PATH
WORKDIR /usr/local
RUN wget https://nodejs.org/download/release/${NODE_V}/node-${NODE_V}-linux-x64.tar.gz && \
  tar -zxvf node-${NODE_V}-linux-x64.tar.gz
RUN npm i -g yarn

# setup golang glide
WORKDIR /usr/local
ENV PATH=$PATH:/usr/local/go/bin
ENV GOPATH=/work/go
ENV PATH=$PATH:$GOPATH/bin
RUN wget https://storage.googleapis.com/golang/go1.8.3.linux-amd64.tar.gz && \
  tar -zxvf go1.8.3.linux-amd64.tar.gz

# Install Chrome for Ubuntu
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
  sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' && \
  apt-get update && \
  apt-get install -y google-chrome-stable

# install chromedriver
WORKDIR /usr/local/share
ENV CHROMEDRIVER_V=2.32
RUN curl -O https://chromedriver.storage.googleapis.com/${CHROMEDRIVER_V}/chromedriver_linux64.zip && \
  unzip chromedriver_linux64.zip && \
  chmod +x chromedriver && \
  ln -s /usr/local/share/chromedriver /usr/local/bin/chromedriver && \
  ln -s /usr/local/share/chromedriver /usr/bin/chromedriver

# setup japanese
RUN wget https://noto-website-2.storage.googleapis.com/pkgs/NotoSansCJKjp-hinted.zip && \
  mkdir /usr/share/fonts/noto && \
  unzip NotoSansCJKjp-hinted.zip NotoSansCJKjp-Regular.otf NotoSansCJKjp-Bold.otf -d /usr/share/fonts/noto/ && \
  fc-cache -v

# install php
RUN apt-get update && \
  apt-get install -y php7.0-fpm php7.0-cli php7.0-curl php7.0-gd php7.0-intl php7.0-pgsql php7.0-mbstring php7.0-pdo php7.0-xmlrpc php7.0-mysqlnd php7.0-mcrypt php7.0-zip php7.0-xml

# install composer
WORKDIR /usr/local/bin
RUN curl -sS https://getcomposer.org/installer | php && \
  mv composer.phar composer

# setup python
WORKDIR /root/
RUN wget https://www.python.org/ftp/python/3.6.0/Python-3.6.0.tgz \
  && tar zxf Python-3.6.0.tgz \
  && cd Python-3.6.0 \
  && ./configure \
  && make altinstall
ENV PYTHONIOENCODING "utf-8"
RUN pip3.6 install selenium

RUN apt-get update && \
  apt-get install -y language-pack-ja-base language-pack-en

ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8
