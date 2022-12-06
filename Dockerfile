FROM debian:bullseye-slim

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC
ENV REVA_VERSION=v2.12.0
RUN mkdir -p /{run,etc}/revad
RUN apt-get update && apt-get install -y  \
  wget \
	vim
RUN wget https://github.com/cs3org/reva/releases/download/${REVA_VERSION}/revad_${REVA_VERSION}_linux_amd64 \
	&& mv revad_${REVA_VERSION}_linux_amd64 /usr/local/bin/revad
RUN chmod +x /usr/local/bin/revad
COPY revad.toml /etc/revad/
CMD /usr/local/bin/revad -c /etc/revad/revad.toml -p /run/revad/revad.pid
