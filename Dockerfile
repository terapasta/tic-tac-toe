FROM ruby:2.3.1

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
                    nodejs \
                    npm \
                    nodejs-legacy \
    && rm -rf /var/lib/apt/lists/*
RUN npm install -g phantomjs-prebuilt

WORKDIR /usr/src/app
COPY Gemfile* ./
# RUN bundle install
ENV BUNDLE_JOBS=4 \
    BUNDLE_PATH=/bundle

COPY . .
