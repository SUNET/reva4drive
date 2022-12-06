FROM debian:bullseye-slim

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC
RUN mkdir -p /{run,etc}/revad
RUN apt-get update && apt-get install -y  \
  wget \
	vim
RUN wget https://github.com/cs3org/reva/releases/download/${REVA_VERSION}/revad_${REVA_VERSION}}_linux_amd64 \
	&& mv revad_${REVA_VERSION}_linux_amd64 /usr/local/bin/revad
COPY revad.service /etc/systemd/system/
COPY revad.toml /etc/revad/
RUN systemctl daemon-reload
RUN systemctl enable revad.service

