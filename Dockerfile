FROM docker.io/openjdk:25-ea-21-jdk-slim
COPY ./target/quarkus-app/quarkus-run.jar ./
CMD ["java", "-jar", "quarkus-run.jar"]
