
#Build Image
ARG NGINX_TAG=1.25-alpine

FROM ubuntu as builder
ARG HUGO_ARCH=linux-amd64
ARG HUGO_VERSION=0.121.0
ARG RELEASE_TAR=https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_${HUGO_ARCH}.tar.gz

WORKDIR /hugo
RUN apt update && apt install curl git -y && rm -rf /var/lib/apt/lists/*
RUN curl -s -L  ${RELEASE_TAR}\
| tar -xvzf - -C /hugo && cp /hugo/hugo /usr/local/bin

WORKDIR /src
COPY . /src
RUN /usr/local/bin/hugo --minify --gc --enableGitInfo

# Final Image
FROM nginx:$NGINX_TAG

COPY --from=builder /src/public/ /usr/share/nginx/html/