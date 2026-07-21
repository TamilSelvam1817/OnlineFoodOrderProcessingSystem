# ===================================================================
# Stage 1: Build Application using Eclipse Temurin Java 21 & Maven Wrapper
# ===================================================================
FROM eclipse-temurin:21-jdk-alpine AS builder
WORKDIR /app

# Copy Maven Wrapper and POM file to cache dependencies
COPY .mvn/ .mvn/
COPY mvnw pom.xml ./
RUN chmod +x mvnw
RUN ./mvnw dependency:go-offline -B

# Copy application source code and build production JAR
COPY src ./src
RUN ./mvnw clean package -DskipTests

# ===================================================================
# Stage 2: Production Lightweight Runtime Image
# ===================================================================
FROM eclipse-temurin:21-jre-alpine AS runner
WORKDIR /app

# Create non-root system user for security
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

# Copy built JAR from builder stage
COPY --from=builder /app/target/*.jar app.jar

EXPOSE 8080

# Launch Spring Boot application
ENTRYPOINT ["java", "-jar", "app.jar"]
