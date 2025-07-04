FROM docker.io/openjdk:25-ea-21-jdk-slim
COPY ./target/quarkus-app/quarkus-run.jar ./
CMD ["java", "-jar", "my-app-1.0.0-SNAPSHOT.jar"]
