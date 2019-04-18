FROM node:9

ENV APP_HOME /bot-framework
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD package.json* $APP_HOME/
ADD yarn.lock* $APP_HOME/

RUN yarn install

WORKDIR $APP_HOME/
ADD . $APP_HOME

CMD node index.js