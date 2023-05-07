# Use a Java runtime as a base image
FROM openjdk:11-jre-slim

# Set the working directory to /app
WORKDIR /app

# Copy the source code and pom.xml into the container at /app
COPY src/ /app/src/
COPY pom.xml /app/

# Install Maven and other necessary tools
RUN apt-get update && apt-get install -y maven

# Build the application with Maven
RUN mvn package

# Expose port 8080 for the web app to listen on
EXPOSE 8080

# Start the application
CMD ["java", "-jar", "target/my-webapp.jar"]
