# =========================
# Stage 1: Build the JAR
# =========================
FROM openjdk:17-jdk-slim AS build

# Set working directory inside the container
WORKDIR /app

# Copy Maven wrapper files first to leverage Docker caching
COPY mvnw .
COPY .mvn .mvn

# Copy the pom.xml (dependencies configuration)
COPY pom.xml .

# Download dependencies offline, so future builds are faster if pom.xml unchanged
RUN ./mvnw dependency:go-offline

# Copy the source code
COPY src ./src

# Build the JAR, skipping tests for faster CI/CD builds
RUN ./mvnw clean package -DskipTests

# =========================
# Stage 2: Runtime image
# =========================
FROM openjdk:17-jdk-slim

# Set working directory for running the app
WORKDIR /app

# Copy only the final JAR from the build stage
COPY --from=build /app/target/dearlavion-authentication-service.jar ./dearlavion-authentication-service.jar

# Command to run the JAR when the container starts
CMD ["java", "-jar", "dearlavion-authentication-service.jar"]
