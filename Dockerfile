FROM ruby:2.4.2

ENV LANG C.UTF-8
RUN apt-get update -qq \
    && apt-get install -y --no-install-recommends \
                    build-essential \
                    libmecab2 \
                    libmecab-dev \
                    mecab \
                    mecab-ipadic \
                    mecab-ipadic-utf8 \
                    mecab-utils \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g yarn

WORKDIR /tmp
RUN apt-get update \
    && apt-get -y install zip unzip xvfb libgconf2-4 libnss3-1d libxss1 libasound2 libatk1.0-0 libcups2 libgtk-3-0 libxcomposite1 libxcursor1 libxi6 libxrandr2 libxtst6 fonts-liberation libappindicator1 lsb-release xdg-utils \
    && wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && dpkg -i google-chrome-stable_current_amd64.deb \
    && apt-get -fy install \
    && wget https://chromedriver.storage.googleapis.com/2.34/chromedriver_linux64.zip \
    && unzip chromedriver_linux64.zip \
    && cp chromedriver /usr/local/bin/chromedriver

WORKDIR /usr/src/app
COPY Gemfile* ./
# RUN bundle install
ENV BUNDLE_JOBS=4 \
    BUNDLE_PATH=/bundle

ENV LANG C.UTF-8
ENV PYTHON_VERSION 3.5.2
ENV PYTHON_PIP_VERSION 9.0.3

WORKDIR /tmp
RUN apt-get -y install python-dev libxml2-dev libxslt-dev \
    && set -ex \
    && curl -fSL "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz" -o python.tar.xz \
    && mkdir -p /usr/src/python \
    && tar -xJC /usr/src/python --strip-components=1 -f python.tar.xz \
    && rm python.tar.xz \
    && cd /usr/src/python \
    && ./configure --enable-shared --enable-unicode=ucs4 \
    && make -j$(nproc) \
    && make install \
    && ldconfig \
    && pip3 install --no-cache-dir --upgrade --ignore-installed pip==$PYTHON_PIP_VERSION \
    && find /usr/local \
        \( -type d -a -name test -o -name tests \) \
        -o \( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
        -exec rm -rf '{}' + \
    && rm -rf /usr/src/python ~/.cache
# SymbolicLinkを作っておく
RUN cd /usr/local/bin \
    && ln -s easy_install-3.5 easy_install \
    && ln -s idle3 idle \
    && ln -s pydoc3 pydoc \
    && ln -s python3 python \
    && ln -s python3-config python-config

RUN mkdir -p ~/neologd-tmp \
    && cd ~/neologd-tmp \
    && git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git \
    && cd mecab-ipadic-neologd \
    && mkdir -p /usr/lib/mecab/dic \
    && ./bin/install-mecab-ipadic-neologd -n -y

COPY . .
