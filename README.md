# <img src="https://calumcrawford.com/favicons/apple-touch-icon.png" alt="calumcrawford.com logo" height=30 /> calumcrawford.com

> Source for calumcrawford.com.

## Prerequisites
* [Hugo](https://gohugo.io/) - Static site generator
* [Docker](https://docker.com) - Containers (Optional)

## Bumping Versions
### CI/CD
In the drone.yml file ammend the following YMAL variables:
```yaml
hugo_version: &hugo_version 0.121.0
nginx_tag: &nginx_tag 1.25-alpine
```
### Manual
```sh
docker build --build-arg NGINX_TAG=1.25-alpine --build-arg HUGO_VERSION=0.121.0
```


## Installation
### Local – Docker
```sh
$ git clone --recurse-submodules https://git.14zombies.com/cal/calumcrawford.com.git
$ cd calumcrawford.com
$ docker run --rm -d -p 8000:80 --name calumcrawford.com $(docker build -q . --build-arg ARCH=linux-amd64)
or on Apple Silicon for local testing
$ docker run --rm -d -p 8000:80 --name calumcrawford.com $(docker build -q . --build-arg ARCH=linux-arm64)
```

The site will then be availible on [localhost:8000](https://localhost:8000)

### Local – Hugo Server
```sh
$ git clone --recurse-submodules https://github.com/14zombies/calumcrawford.com
$ cd calumcrawford.com
$ hugo server -w
```

## Info
* Theme: [hugo-coder](https://github.com/luizdepra/hugo-coder)
* Hex for favicon is #cc0000

## Authors
* [**Calum Crawford**](https://calumcrawford.com)
