# NGINX Server Setup

FROM ubuntu:16.04

RUN true \
  && apt-get update -y                             \
  && apt-get upgrade -y                            \ 
  && apt-get install -y software-properties-common \
  && add-apt-repository -y ppa:nginx/stable        \
  && apt-get update -y                             \
  && apt-get install -y vim 

RUN true \
  && apt-get install -y nginx     \
  && rm -rf /var/lib/apt/lists/*  \
  && echo "\ndaemon off;" >> /etc/nginx/nginx.conf \
  && chown -R www-data:www-data /var/lib/nginx 

RUN true \
  && add-apt-repository -y ppa:certbot/certbot     \
  && apt-get update -y                             \
  && apt-get install -y python-certbot-nginx       \
  && rm -rf /etc/letsencrypt                       \
  && ln -s /etc/letsencrypt_local /etc/letsencrypt 

VOLUME ["/etc/nginx", "/var/log/nginx", "/var/www", "/etc/letsencrypt_local"]

WORKDIR /etc/nginx

CMD ["nginx"]

EXPOSE 80
EXPOSE 443

