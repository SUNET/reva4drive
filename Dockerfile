FROM golang:bookworm
RUN mkdir /build && cd /build && git clone https://github.com/cs3org/reva.git && cd reva && git checkout tags/v1.26.0
WORKDIR /build/reva/
RUN make revad

FROM debian:bookworm-slim
COPY --from=0 /build/reva/cmd/revad/revad /usr/local/bin/revad
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC
ENV REVA_VERSION=v1.26.0
RUN mkdir -p /etc/revad/tls
RUN mkdir -p /run/revad
RUN apt-get update && apt-get install -y  \
	vim \
  wget 
COPY --chown=root:root ./start.sh /
COPY --chown=root:root ./revad.toml /etc/revad/
RUN chmod +x /usr/local/bin/revad /start.sh
RUN usermod -a -G tty www-data
EXPOSE 19001 
CMD /start.sh
