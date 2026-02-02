FROM eclipse-temurin:21-jdk-alpine as build

COPY . /app
WORKDIR /app

RUN chmod +x mvnw
RUN ./mvnw clean package -DskipTests
RUN mv -f target/*.jar app.jar

FROM eclipse-temurin:21-jre-alpine

ARG PORT
ENV PORT=${PORT}

COPY --from=build /app/app.jar .

RUN groupadd --gid 1001 appuser \
    && useradd --uid 1001 --gid appuser --shell /bin/bash --create-home appuser

USER appuser

ENTRYPOINT [ "java", "-Dserver.port=${PORT}", "-jar", "app.jar" ]
