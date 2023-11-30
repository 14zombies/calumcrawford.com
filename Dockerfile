ARG NGINX_TAG
FROM nginx:$NGINX_TAG

COPY public/ /usr/share/nginx/html/