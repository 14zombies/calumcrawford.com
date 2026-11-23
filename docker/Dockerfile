
ARG ALPINE_VERSION=3
ARG DART_SASS_VERSION=1.108.2
ARG NGINX_TAG=1-alpine-slim
ARG HUGO_VERSION=0.170.1

#Build Image
FROM alpine:${ALPINE_VERSION} AS builder
ARG DOMAIN=localhost
ARG TARGETARCH
ARG TARGETOS
ARG DART_SASS_VERSION
ARG HUGO_VERSION
ARG HUGO_ARCH=${TARGETOS}-${TARGETARCH}
ARG build_temp_dir=/tmp
ARG RELEASE_TAR=https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_${HUGO_ARCH}.tar.gz
WORKDIR /hugo
RUN apk add --update libc6-compat libstdc++ git curl
RUN curl -sfLO --output-dir "${build_temp_dir}" "https://github.com/sass/dart-sass/releases/download/${DART_SASS_VERSION}/dart-sass-${DART_SASS_VERSION}-${HUGO_ARCH}.tar.gz"
RUN ls -la /tmp
RUN tar -C "/opt" -xf "${build_temp_dir}/dart-sass-${DART_SASS_VERSION}-${HUGO_ARCH}.tar.gz"
ENV PATH="/opt/dart-sass:${PATH}"
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
COPY ./keys /usr/share/nginx/keys
RUN cd /usr/share/nginx/keys && sha256sum -- * > SHAFILE


