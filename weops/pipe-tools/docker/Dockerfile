#
# build container
#
FROM --platform=linux/amd64 openjdk:19-jdk-alpine3.16  as builder
WORKDIR /

COPY jdbc_exporter_linux_amd64 /jdbc_exporter_linux_amd64

EXPOSE     9601
ENTRYPOINT [ "/jdbc_exporter_linux_amd64" ]
