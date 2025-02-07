#
# build container
#
FROM --platform=linux/amd64 openjdk:7-jdk-alpine3.8 as builder
WORKDIR /

COPY mongodb_exporter /mongodb_exporter

EXPOSE     9601
ENTRYPOINT [ "/jdbc_exporter" ]
