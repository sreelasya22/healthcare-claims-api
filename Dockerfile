# ─────────────────────────────────────────────────────────────────────────────
# Stage 1: BUILD
# Use Maven + Java 17 to compile and package the Spring Boot app into a JAR
# ─────────────────────────────────────────────────────────────────────────────
FROM maven:3.9.6-eclipse-temurin-17 AS build

# Set working directory inside the container
WORKDIR /app

# Copy the Maven project file first (so Docker caches dependencies separately)
COPY pom.xml .

# Download all dependencies (this layer is cached unless pom.xml changes)
RUN mvn dependency:go-offline -B

# Copy your actual source code
COPY src ./src

# Build the JAR, skipping tests (tests run in the pipeline separately)
RUN mvn clean package -DskipTests


# ─────────────────────────────────────────────────────────────────────────────
# Stage 2: RUN
# Use a lightweight Java 17 image — no Maven needed at runtime
# ─────────────────────────────────────────────────────────────────────────────
FROM eclipse-temurin:17-jre-alpine

# Set working directory
WORKDIR /app

# Copy only the built JAR from Stage 1 (keeps image small)
COPY --from=build /app/target/*.jar app.jar

# Expose port 8080 (default Spring Boot port)
EXPOSE 8080

# Start the Spring Boot application
ENTRYPOINT ["java", "-jar", "app.jar"]
