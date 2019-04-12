FROM golang:1.12.3 AS builder
LABEL maintainer="Ming Cheng"

# Using 163 mirror for Debian Strech
#RUN sed -i 's/deb.debian.org/mirrors.163.com/g' /etc/apt/sources.list
#RUN apt-get update

ENV BUILD_DIR /tmp/genpasswd

# Build
COPY . ${BUILD_DIR}
WORKDIR ${BUILD_DIR}
RUN make clean && go mod download && \
  env GO111MODULE=on GO15VENDOREXPERIMENT=1 make build && \
  mv ${BUILD_DIR}/genpasswd /usr/bin/genpasswd

# Stage2
FROM alpine:3.9.3

# @from https://mirrors.ustc.edu.cn/help/alpine.html
#RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories

COPY --from=builder /usr/bin/genpasswd /bin/genpasswd

ENTRYPOINT ["/bin/genpasswd"]
