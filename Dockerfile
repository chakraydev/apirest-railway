FROM eclipse-temurin:21-jdk-alpine as build

COPY . /app
WORKDIR /app

RUN chmod +x mvnw
RUN ./mvnw clean package -DskipTests
RUN mv -f target/*.jar app.jar

FROM eclipse-temurin:21-jre-alpine as runtime

ARG PORT
ENV PORT=${PORT}

COPY --from=build /app/app.jar .

RUN useradd runtime
USER runtime

ENTRYPOINT [ "java", "-Dserver.port=${PORT}", "-jar", "app.jar" ]
