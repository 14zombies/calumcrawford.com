# <img src="https://calumcrawford.com/favicons/apple-touch-icon.png" alt="calumcrawford.com logo" height=30 /> calumcrawford.com

> Source for calumcrawford.com.

## Prerequisites
* [Hugo](https://gohugo.io/) - Static site generator
* [Docker](https://docker.com) - Containers (Optional)

## Bumping Versions
### CI/CD
In the drone.yml file ammend the following build args:
```yaml
hugo_version
nginx_tag
```
### Manually sepcify versions
```sh
docker build --build-arg NGINX_TAG=1.25-alpine --build-arg HUGO_VERSION=0.121.0
```


## Build
### Local – Docker
```sh
$ git clone --recurse-submodules https://git.14zombies.com/cal/calumcrawford.com.git
$ cd calumcrawford.com
$ docker run --rm -d -p 8000:80 --name calumcrawford.com $(docker build -q -f ./docker/Dockerfile . )
or on Apple Silicon for local testing
$ docker run --rm -d -p 8000:80 --name calumcrawford.com $(docker build -q -f ./docker/Dockerfile.linux.arm64 .)
```

The site will then be availible on [localhost:8000](https://localhost:8000)

### Local – Hugo Server
```sh
$ git clone --recurse-submodules https://github.com/14zombies/calumcrawford.com
$ cd calumcrawford.com
$ hugo server -w
```


### Local – Docker no build
```sh
docker run --rm -d -p 8000:80 --name calumcrawford.com git.14zombies.com/cal/calumcrawford.com
```

## CI/CD - Tags
### dev
Published for every commit.
Used by dev.calumcrawford.com which is runs the latest non-tagged commit.

### latest
Published only for tagged commits.
Used by calumcrawford.com which runs only tagged commits.


## Info
* Theme: [hugo-coder](https://github.com/luizdepra/hugo-coder)
* Hex for favicon is #cc0000

## TODO
    
- Make bumping versions easier
- switch test.calumcrawford.com to dev.calumcrawford.com
- Streamline docker files

## Authors
* [**Calum Crawford**](https://calumcrawford.com)
