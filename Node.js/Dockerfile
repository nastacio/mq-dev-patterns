# https://developer.ibm.com/components/ibm-mq/tutorials/mq-develop-mq-jms/

#
# Stage 1
#
FROM node:12 as build

RUN mkdir /project

WORKDIR /project

COPY package*.json .

RUN npm install

#
# Stage 2
#
FROM node:12-slim

WORKDIR /home/node
COPY --from=build /project/node_modules/ node_modules
COPY ./ .

RUN \
    mkdir -p /IBM/MQ \
    && chown -R node:root /IBM/MQ \
    && chmod -R g+rwx /IBM/MQ \
    && mkdir -p IBM \
    && chown -R node:root IBM \
    && chmod -R g+rwx IBM \
    && mkdir -p .mqm \
    && chown -R node:root .mqm \
    && chmod -R g+rwx .mqm

USER node

ENV HOME=/home/node

CMD \
    DEBUG=amqsput:* node basicput.js
