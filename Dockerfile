FROM node:11.5-alpine

ENV APP_USER app
RUN addgroup -S "$APP_USER" && adduser -S -g "$APP_USER" "$APP_USER"
ENV APP_DIR /app
WORKDIR "$APP_DIR"

ENV BUILD_PACKAGES="\
    openssl \
"

ENV RUNTIME_PACKAGES="\
    autoconf \
    automake \
    build-base \
    bash \
    git \
    libtool \
    man \
    nasm \
    util-linux \
"

RUN apk update && \
    apk upgrade && \
    apk add --no-cache --virtual .build-packages $BUILD_PACKAGES && \
    apk add --no-cache --virtual .runtime-packages $RUNTIME_PACKAGES

ENV NODE_MODULES_FOLDER "$APP_DIR/node_modules"
ENV NODE_BIN_FOLDER "$NODE_MODULES_FOLDER/.bin"

RUN mkdir -p "$APP_DIR" "$NODE_MODULES_FOLDER"

COPY package.json "$APP_DIR/"
COPY yarn.lock "$APP_DIR/"
RUN yarn install

COPY . "$APP_DIR"

RUN chown -R "$APP_USER":"$APP_USER" \
    "$APP_DIR" \
    "$NODE_MODULES_FOLDER"

RUN rm -rf /tmp/*

USER "$APP_USER"

ENV PATH "$PATH:$NODE_BIN_FOLDER"
ENV SHELL /bin/bash

ENTRYPOINT ["yarn"]
