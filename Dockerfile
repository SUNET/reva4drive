FROM debian:bullseye-slim

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC
ENV REVA_VERSION=v2.12.0
RUN mkdir -p /etc/revad/tls
RUN mkdir -p /run/revad
RUN mkdir -p /var/tmp/reva
RUN touch /var/tmp/reva/ocm-invites.json
RUN apt-get update && apt-get install -y  \
	vim \
  wget 
RUN wget https://github.com/cs3org/reva/releases/download/${REVA_VERSION}/revad_${REVA_VERSION}_linux_amd64 \
	&& mv revad_${REVA_VERSION}_linux_amd64 /usr/local/bin/revad
COPY --chown=root:root ./start.sh /
COPY --chown=root:root ./revad.toml /etc/revad/
RUN chmod +x /usr/local/bin/revad /start.sh
RUN usermod -a -G tty www-data
EXPOSE 19001 
CMD /start.sh
