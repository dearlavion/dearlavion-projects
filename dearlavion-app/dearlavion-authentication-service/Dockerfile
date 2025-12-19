FROM openjdk:17-jdk-slim
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN ./mvnw clean package -DskipTests
CMD ["java", "-jar", "target/dearlavion-authentication-service.jar"]
