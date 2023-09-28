FROM golang:bookworm
ARG REVA_VERSION=v1.26.0
RUN mkdir /build && cd /build && git clone https://github.com/cs3org/reva.git && cd reva && git checkout tags/${REVA_VERSION}
WORKDIR /build/reva/
RUN make revad

FROM debian:bookworm-slim
COPY --from=0 /build/reva/cmd/revad/revad /usr/local/bin/revad
ARG DEBIAN_FRONTEND=noninteractive
ARG REVA_VERSION
ENV TZ=Etc/UTC
ENV REVA_VERSION=${REVA_VERSION}
RUN mkdir -p /etc/revad/tls
RUN mkdir -p /run/revad
RUN apt-get update && apt-get install -y  \
  gawk \
	vim \
  wget
RUN apt-get remove -y mawk
RUN wget -q https://downloads.rclone.org/rclone-current-linux-amd64.deb \
  && dpkg -i ./rclone-current-linux-amd64.deb \
  && rm ./rclone-current-linux-amd64.deb && rm -rf /var/lib/apt/lists/*
COPY --chown=root:root ./start.sh /
COPY --chown=root:root ./metrics.sh /
COPY --chown=root:root ./metrics.json /etc/revad/
COPY --chown=root:root ./revad.toml /etc/revad/
RUN chmod +x /usr/local/bin/revad /start.sh
RUN usermod -a -G tty www-data
EXPOSE 19001
CMD /start.sh
