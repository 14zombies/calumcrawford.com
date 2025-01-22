# <img src="https://calumcrawford.com/favicons/apple-touch-icon.png" alt="calumcrawford.com logo" height=30 /> calumcrawford.com

> Source for calumcrawford.com.

## Prerequisites
* [Hugo](https://gohugo.io/) - Static site generator
* [Docker](https://docker.com) - Containers (Optional)

## Bumping Versions
### CI/CD
In the drone.yml file ammend the following build args:
```yaml
HUGO_VERSION
NGINX_TAG
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

## Webfinger
Thanks to [Serving webfinger resources with nginx](https://fnordig.de/2023/01/02/serving-webfinger-resources-with-nginx/)

Briefly, Nginx rewrites any request's made to .well-known/webfinger based on the resource=acct:user parameter.

Mappings for this rewrite are contained in nginx/includes/webfinger_map.conf

Location of files to rewrite the request to is contained in nginx/includes/webfinger.conf while the files themselves are in the webfinger folder.

As an example for Mastodon the webfinger will request ${DOMAIN}/.well-known/webfinger?resource=acct:14zombies@mastodon.social.
14zombies@mastodon.social is mapped to "mastodon" in webfinger_map.conf
The include webfinger.conf then directs nginx to serve /usr/share/nginx/webfinger/mastodon.json.

>[!NOTE]
> As noted in the above mentioned blog post this will only work where "resource=" is the last query parameter.


## Info
* Theme: [hugo-coder](https://github.com/luizdepra/hugo-coder)
* Hex for favicon is #cc0000

## TODO
    
- Make bumping versions easier

## Authors
* [**Calum Crawford**](https://calumcrawford.com)
