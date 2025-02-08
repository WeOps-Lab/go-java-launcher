#
# build container
#
FROM --platform=linux/amd64 openjdk:24-ea-11-jdk  as builder
WORKDIR /

COPY jdbc_exporter_linux_amd64 /jdbc_exporter_linux_amd64

EXPOSE     9601
ENTRYPOINT [ "/jdbc_exporter_linux_amd64" ]
