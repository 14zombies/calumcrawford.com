
ARG ALPINE_VERSION=3
ARG NGINX_TAG=1-alpine-slim
ARG HUGO_VERSION=0.141.0

#Build Image
FROM alpine:${ALPINE_VERSION} AS builder
ARG DOMAIN=localhost
ARG TARGETARCH
ARG TARGETOS
ARG HUGO_VERSION
ARG HUGO_ARCH=${TARGETOS}-${TARGETARCH}
ARG RELEASE_TAR=https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_${HUGO_ARCH}.tar.gz
WORKDIR /hugo
RUN apk add --update libc6-compat libstdc++ git curl
RUN curl -s -L  ${RELEASE_TAR}\
    | tar -xvzf - -C /hugo && \
    cp /hugo/hugo /usr/local/bin
WORKDIR /src
COPY . /src
RUN /usr/local/bin/hugo --minify --gc -b ${DOMAIN}

# Final Image
ARG NGINX_TAG
FROM nginx:$NGINX_TAG
LABEL maintainer="Calum Crawford <c@calumcrawford.com>"
LABEL title="calumcrawford.com"
LABEL description="Image for calumcrawford.com"
COPY --from=builder /src/public/ /usr/share/nginx/html/
COPY ./nginx/default.conf.template /etc/nginx/templates/default.conf.template
COPY ./nginx/includes /etc/nginx/includes
COPY ./webfinger /usr/share/nginx/webfinger

