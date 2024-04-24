
#Build Image
ARG NGINX_TAG=1.25.5-alpine-slim@sha256:9ae24f8486756d832a21a892a499c54d45a8b67ecc16e6a6b5f80eb741979cda

FROM debian:stable-slim as builder
ARG DOMAIN=localhost
ARG HUGO_ARCH=linux-amd64
ARG HUGO_VERSION=0.121.0
ARG RELEASE_TAR=https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_${HUGO_ARCH}.tar.gz

WORKDIR /hugo
RUN apt update && apt install git curl -y && rm -rf /var/lib/apt/lists/*
RUN curl -s -L  ${RELEASE_TAR}\
    | tar -xvzf - -C /hugo && \
    cp /hugo/hugo /usr/local/bin

WORKDIR /src
COPY . /src
RUN /usr/local/bin/hugo --minify --gc --enableGitInfo -b ${DOMAIN}

# Final Image
ARG NGINX_TAG
FROM nginx:$NGINX_TAG
LABEL maintainer="Calum Crawford <c@calumcrawford.com>"
COPY --from=builder /src/public/ /usr/share/nginx/html/
