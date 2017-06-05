FROM ruby:2.3.1

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

WORKDIR /usr/src/app
COPY Gemfile* ./
ENV BUNDLE_JOBS=4 \
    BUNDLE_PATH=/bundle
