FROM docker.io/openjdk:11
COPY target/testk8s-0.0.1-SNAPSHOT.jar /testk8s.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/testk8s.jar"]
