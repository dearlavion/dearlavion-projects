# Stage 1: Build
FROM eclipse-temurin:21-jdk AS build
WORKDIR /app

COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .
RUN ./mvnw dependency:go-offline
COPY src ./src
RUN ./mvnw clean package -DskipTests

# Stage 2: Runtime
FROM openjdk:21-jdk-slim
WORKDIR /app
COPY --from=build /app/target/dearlavion-authentication-service.jar ./dearlavion-authentication-service.jar
CMD ["java", "-jar", "dearlavion-authentication-service.jar"]
