FROM alpine:3.10
LABEL maintainer="Victor Barrera"

ENV KONG_VERSION 2.0.3
ENV KONG_SHA256 db6a8ac847c347fb4d49c4763181c529bb9584187cdccdcc657ce00d605c99ac

RUN adduser -S kong \
	&& mkdir -p "/usr/local/kong" \
	&& apk add --no-cache --virtual .build-deps curl wget tar ca-certificates \
	&& apk add --no-cache libgcc openssl pcre perl tzdata libcap su-exec zip \
	&& wget -O kong.tar.gz "https://bintray.com/kong/kong-alpine-tar/download_file?file_path=kong-$KONG_VERSION.amd64.apk.tar.gz" \
	&& echo "$KONG_SHA256 *kong.tar.gz" | sha256sum -c - \
	&& tar -xzf kong.tar.gz -C /tmp \
	&& rm -f kong.tar.gz \
	&& cp -R /tmp/usr / \
	&& rm -rf /tmp/usr \
	&& cp -R /tmp/etc / \
	&& rm -rf /tmp/etc \
	&& chown -R kong:0 /usr/local/kong \
	&& chmod -R g=u /usr/local/kong

RUN apk update
RUN	apk upgrade
RUN	apk add --no-cache bash git openssh

RUN git clone https://github.com/victorbt/kong-plugin-insaite-auth.git \
	&& mkdir "/usr/local/kong/plugins" \
	&& mv kong-plugin-insaite-auth/ usr/local/kong/plugins/kong-plugin-insaite-auth

WORKDIR /usr/local/kong/plugins/kong-plugin-insaite-auth

RUN luarocks make

WORKDIR /

USER kong

COPY docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

# RUN ["chmod", "+x", "docker-entrypoint.sh"]

EXPOSE 8000 8443 8001 8444

STOPSIGNAL SIGQUIT

CMD ["kong", "docker-start"]