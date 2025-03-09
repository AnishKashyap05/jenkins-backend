# Use Maven as the build stage
FROM maven:3.8.5-openjdk-17-slim AS builder

# Set working directory
WORKDIR /app

# Copy pom.xml and download dependencies (to leverage Docker cache)
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy the entire project and build the JAR
COPY . .
RUN mvn clean package -DskipTests

# Use OpenJDK as the runtime stage
FROM openjdk:17-jdk-slim

# Set working directory
WORKDIR /app

# Copy the JAR file from the builder stage
COPY --from=builder /app/target/*.jar app.jar

# Expose the application port
EXPOSE 8081

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
