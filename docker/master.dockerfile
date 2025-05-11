FROM amazoncorretto:24-alpine3.21-jdk

LABEL org.opencontainers.image.authors="https://github.com/piotr-rzepa"

EXPOSE 35353/tcp

ARG MULTIPAPER_MC_VERSION

ARG MULTIPAPER_BUILD_NUMBER

ARG MULTIPAPER_MASTER_VERSION

WORKDIR /minecraft

ADD https://api.multipaper.io/v2/projects/multipaper/versions/${MULTIPAPER_MC_VERSION}/builds/${MULTIPAPER_BUILD_NUMBER}/downloads/multipaper-master-${MULTIPAPER_MASTER_VERSION}-all.jar master.jar

ENTRYPOINT [ "java" ]

CMD [ "-Xmx1024M", "-Xms1024M", "-jar", "master.jar", "35353"]
