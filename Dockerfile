FROM alpine:3.7
MAINTAINER XiangJL xjl-tommy@qq.com

RUN apk add --no-cache nodejs && \
    apk add --no-cache g++ gcc git make bash python && \
    npm install -g --unsafe-perm storjshare-daemon && \
    npm cache clear --force && \
    apk del --no-cache g++ gcc git make bash python && \
    mkdir /docker

ENV USE_HOSTNAME_SUFFIX=FALSE
ENV DATADIR=/storj
ENV WALLET_ADDRESS=
ENV SHARE_SIZE=1TB
ENV RPCADDRESS=127.0.0.1

EXPOSE 4000-4003/tcp

ADD startup.sh /docker

ENTRYPOINT ["/docker/startup.sh"]
