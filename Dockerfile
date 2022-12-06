FROM debian:bullseye-slim

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC
ENV REVA_VERSION=v2.12.0
RUN mkdir -p /etc/revad
RUN mkdir -p /run/revad
RUN apt-get update && apt-get install -y  \
  apache2 \
  ssl-cert \
	vim \
  wget 
RUN wget https://github.com/cs3org/reva/releases/download/${REVA_VERSION}/revad_${REVA_VERSION}_linux_amd64 \
	&& mv revad_${REVA_VERSION}_linux_amd64 /usr/local/bin/revad
COPY --chown=root:root ./start.sh /
COPY --chown=root:root ./revad.toml /etc/revad/
COPY --chown=root:root ./000-default.conf /etc/apache2/sites-available/
RUN chmod +x /usr/local/bin/revad /start.sh
RUN mkdir -p /etc/apache2/mods-enabled/ \
	&& ln -s /etc/apache2/mods-available/rewrite.load  /etc/apache2/mods-enabled/ \
	&& ln -s /etc/apache2/mods-available/socache_shmcb.load /etc/apache2/mods-enabled/ \
	&& ln -s /etc/apache2/mods-available/proxy.conf /etc/apache2/mods-enabled/ \
	&& ln -s /etc/apache2/mods-available/proxy.load /etc/apache2/mods-enabled/ \
	&& ln -s /etc/apache2/mods-available/proxy_http.load /etc/apache2/mods-enabled/ \
	&& ln -s /etc/apache2/mods-available/proxy_http2.load /etc/apache2/mods-enabled/ \
	&& ln -s /etc/apache2/mods-available/ssl.conf /etc/apache2/mods-enabled/ \
	&& ln -s /etc/apache2/mods-available/ssl.load /etc/apache2/mods-enabled/
RUN usermod -a -G tty www-data
EXPOSE 19443 
CMD /start.sh
