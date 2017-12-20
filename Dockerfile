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
    && apt-get install -y nodejs

WORKDIR /tmp
RUN apt-get update \
    && apt-get -y install zip unzip xvfb libgconf2-4 libnss3-1d libxss1 libasound2 libatk1.0-0 libcups2 libgtk-3-0 libxcomposite1 libxcursor1 libxi6 libxrandr2 libxtst6 fonts-liberation libappindicator1 lsb-release xdg-utils \
    && wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && dpkg -i google-chrome-stable_current_amd64.deb \
    && apt-get -fy install \
    && wget https://chromedriver.storage.googleapis.com/2.29/chromedriver_linux64.zip \
    && unzip chromedriver_linux64.zip \
    && cp chromedriver /usr/local/bin/chromedriver

WORKDIR /usr/src/app
COPY Gemfile* ./
# RUN bundle install
ENV BUNDLE_JOBS=4 \
    BUNDLE_PATH=/bundle

COPY . .
