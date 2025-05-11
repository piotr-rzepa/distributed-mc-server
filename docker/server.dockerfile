FROM amazoncorretto:24-alpine3.21-jdk

LABEL org.opencontainers.image.authors="https://github.com/piotr-rzepa"

EXPOSE 25565/tcp

ARG MULTIPAPER_MC_VERSION

ARG MULTIPAPER_BUILD_NUMBER

WORKDIR /minecraft
ADD https://api.multipaper.io/v2/projects/multipaper/versions/${MULTIPAPER_MC_VERSION}/builds/${MULTIPAPER_BUILD_NUMBER}/downloads/multipaper-${MULTIPAPER_MC_VERSION}-${MULTIPAPER_BUILD_NUMBER}.jar server.jar

ENTRYPOINT [ "java" ]

CMD ["-Xmx1024M", "-Xms1024M", "-jar", "server.jar", "nogui"]
