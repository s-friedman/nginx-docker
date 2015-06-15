FROM nginx
MAINTAINER zsx <thinkernel@gmail.com>

COPY proxy.conf /etc/nginx/conf.d/default.conf

COPY nginx-entrypoint.sh /usr/local/bin/nginx-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/nginx-entrypoint.sh"]
