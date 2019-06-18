FROM alpine:latest as builder
RUN apk add --no-cache curl bash gnupg

ARG plugins="http.cache,http.cors,http.expires,http.realip,http.git"
RUN curl https://getcaddy.com | bash -s personal ${plugins}

FROM alpine:latest

RUN apk add --no-cache openssh-client ca-certificates git

COPY --from=builder ["/usr/local/bin/caddy","/usr/local/bin/"]

ENV CADDYPATH="/caddy/.caddy"

WORKDIR /caddy
RUN mkdir -p "etc" "www" "logs"
VOLUME ["/caddy"]

EXPOSE 80 443
CMD ["caddy","-agree","-conf","etc/Caddyfile","--log","stdout"]