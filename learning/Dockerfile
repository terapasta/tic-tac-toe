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

RUN echo 'userdic = /usr/src/app/dict/custom.dic' >> /etc/mecabrc

COPY ./requirements.txt .
RUN pip install -r requirements.txt

RUN cd /tmp \
    && mkdir -p `mecab-config --dicdir` \
    && git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git \
    && cd mecab-ipadic-neologd \
    && ./bin/install-mecab-ipadic-neologd -n -y

COPY . .
