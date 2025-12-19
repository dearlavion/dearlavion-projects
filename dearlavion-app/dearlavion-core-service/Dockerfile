# Stage 1: Build
FROM openjdk:21-jdk-slim AS build
WORKDIR /app

# Copy Maven wrapper and pom.xml first to leverage caching
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .

# Download dependencies only
RUN ./mvnw dependency:go-offline

# Copy source code and build JAR
COPY src ./src
RUN ./mvnw clean package -DskipTests

# Stage 2: Runtime
FROM openjdk:21-jdk-slim
WORKDIR /app

# Copy the built JAR from build stage
COPY --from=build /app/target/dearlavion-core-service.jar ./dearlavion-core-service.jar

# Run the JAR
CMD ["java", "-jar", "dearlavion-core-service.jar"]
