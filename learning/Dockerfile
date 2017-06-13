FROM python:3.5.2

RUN apt-get -qqy update \
    && apt-get -qqy upgrade \
    && apt-get -y --no-install-recommends install \
        build-essential \
        libmecab2 \
        libmecab-dev \
        mecab \
        mecab-ipadic \
        mecab-ipadic-utf8 \
        mecab-utils \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app
COPY ./requirements.txt .
RUN pip install -r requirements.txt
