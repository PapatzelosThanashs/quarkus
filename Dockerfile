FROM docker.io/openjdk:25-ea-21-jdk-slim 
WORKDIR /app
COPY target/quarkus-app/ ./
CMD ["java", "-jar", "quarkus-run.jar"]
 