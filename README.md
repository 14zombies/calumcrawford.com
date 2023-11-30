# <img src="https://calumcrawford.com/favicons/apple-touch-icon.png" alt="calumcrawford.com logo" height=30 /> calumcrawford.com

> Source for calumcrawford.com.

## Prerequisites
* [Hugo](https://gohugo.io/) - Static site generator
* [Docker](https://docker.com) - Containers (Optional)

## Bumping Versions
### CI/CD
In the drone.yml file ammend the following YMAL variables:
```yaml
hugo_version: &hugo_version 0.120.4
nginx_tag: &nginx_tag 1.25-alpine
```
### Manual
```sh
docker build --build-arg NGINX_TAG=1.25-alpine
```


## Installation
### Local – Docker
```sh
$ git clone --recurse-submodules https://github.com/14zombies/calumcrawford.com
$ cd calumcrawford.com
$ hugo
$ docker run --rm -d -p 8000:80 --name calumcrawford.com $(docker build -q .)
```

### Local – Hugo Server
```sh
$ git clone --recurse-submodules https://github.com/14zombies/calumcrawford.com
$ cd calumcrawford.com
$ hugo server -w
```

### Pull from github.
```sh
$ docker run --rm -d -p 8000:80 --name calumcrawford.com ghcr.io/14zombies/calumcrawford.com
```

## Info
* Theme: [hugo-coder](https://github.com/luizdepra/hugo-coder)
* Hex for favicon is #cc0000

## Authors
* [**Calum Crawford**](https://calumcrawford.com)
