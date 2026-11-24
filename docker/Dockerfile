
ARG ALPINE_VERSION=3
ARG NGINX_TAG=1-alpine-slim
ARG HUGO_VERSION=0.170.1

# dart-sass
FROM alpine:${ALPINE_VERSION} AS dart-sass
ARG TARGETARCH
RUN apk add jq curl
RUN curl -s https://api.github.com/repos/sass/dart-sass/releases/latest | \
    jq -r --arg REGEXP "^.+-linux-${TARGETARCH/amd64/x64}-musl.tar.gz$" '.assets[].browser_download_url | match($REGEXP) | .string' | \
    xargs -n1 curl -L -o dart-sass.tar.gz
RUN tar -C /opt -xzf dart-sass.tar.gz

#Hugo
FROM alpine:${ALPINE_VERSION} AS hugo
ARG TARGETARCH
ARG TARGETOS
ARG HUGO_VERSION
ARG HUGO_ARCH=${TARGETOS}-${TARGETARCH}
ARG RELEASE_TAR=https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_${HUGO_ARCH}.tar.gz
WORKDIR /opt/hugo
RUN apk add --update libc6-compat libstdc++ git curl
RUN curl -s -L  ${RELEASE_TAR}\
    | tar -xvzf - -C /opt/hugo

#Build Image
FROM alpine:${ALPINE_VERSION} AS builder
ARG DOMAIN=localhost
WORKDIR /src
RUN apk add --update libc6-compat libstdc++ git curl
COPY --from=dart-sass /opt/dart-sass /opt/dart-sass
COPY --from=hugo /opt/hugo/hugo /opt/hugo/hugo
ENV PATH="/opt/dart-sass:/opt/hugo:${PATH}"
COPY . /src
RUN hugo --minify --gc -b ${DOMAIN}

# Final Image
FROM nginx:$NGINX_TAG
ARG NGINX_TAG
LABEL maintainer="Calum Crawford <c@calumcrawford.com>"
LABEL title="calumcrawford.com"
LABEL description="Image for calumcrawford.com"
COPY --from=builder /src/public/ /usr/share/nginx/html/
COPY ./nginx/default.conf.template /etc/nginx/templates/default.conf.template
COPY ./nginx/includes /etc/nginx/includes
COPY ./webfinger /usr/share/nginx/webfinger
COPY ./keys /usr/share/nginx/keys
RUN cd /usr/share/nginx/keys && sha256sum -- * > SHAFILE

