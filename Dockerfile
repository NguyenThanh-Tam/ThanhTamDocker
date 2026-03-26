# Stage 1: Build the application
FROM maven:3.9.6-eclipse-temurin-21 AS builder

# Set the working directory
WORKDIR /build

# Copy the POM file and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy the source code
COPY src ./src

# Build the application
RUN mvn clean package -DskipTests

# Stage 2: Create the final image
FROM eclipse-temurin:21-jre-alpine

# Set the working directory
WORKDIR /app

# Copy the jar from the builder stage
# Using *.jar to match the artifact version dynamically
COPY --from=builder /build/target/*.jar app.jar

# Expose the port the app runs on
EXPOSE 8080

# Run the jar file
ENTRYPOINT ["java","-jar","app.jar"]
