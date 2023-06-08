# Use a base image with Java 11 and Maven pre-installed
FROM maven:3.9.2-eclipse-temurin-11 AS build

# Set the working directory in the container
WORKDIR /app

# Copy the pom.xml file to the container
COPY pom.xml .

# Resolve Maven dependencies (downloads dependencies defined in pom.xml)
RUN mvn dependency:go-offline

# Copy the rest of the application source code to the container
COPY src ./src

# Build the application
RUN mvn package

# Create a new image with only the compiled application
FROM openjdk:11-jre-slim

# Set the working directory in the container
WORKDIR /app

# Copy the compiled application from the build image to the final image
COPY --from=build /app/target/mavenproject1-1.0-SNAPSHOT.jar .

# Set the command to run the application
CMD ["java", "-jar", "mavenproject1-1.0-SNAPSHOT.jar"]
