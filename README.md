# <img src="https://calumcrawford.com/img/apple-touch-icon.png" alt="calumcrawford.com logo" height=30 /> calumcrawford.com

> Source for calumcrawford.com with github actions.

## Prerequisites
* [Hugo](https://gohugo.io/) - Static site generator
* [Docker](https://docker.com) - Containers (Optional)

## Installation
### Local – Docker
```zsh
$ git clone --recurse-submodules https://github.com/14zombies/calumcrawford.com
$ cd calumcrawford.com
$ hugo
$ docker run --rm -d -p 8000:80 --name calumcrawford.com $(docker build -q .)
```

### Local – Hugo Server
```zsh
$ git clone --recurse-submodules https://github.com/14zombies/calumcrawford.com
$ cd calumcrawford.com
$ hugo server -w
```

### Pull from github.
```bash
$ docker run --rm -d -p 8000:80 --name calumcrawford.com ghcr.io/14zombies/calumcrawford.com
```

## Documentation

For the moment this is built using github actions and deployed using watchtower.

This will eventually move to selfhosted gitea and drone.

## Info
* Theme: [hugo-coder](https://github.com/luizdepra/hugo-coder)
* Hex for favicon is #cc0000

## Authors
* [**Calum Crawford**](https://calumcrawford.com)
