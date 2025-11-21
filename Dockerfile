# Multi-stage build for production
FROM maven:3.8.6-openjdk-11-slim AS builder

WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline -B

COPY src ./src
RUN mvn clean package -DskipTests

# Production image
FROM tomcat:10-jdk11-openjdk-slim

# Create non-root user
RUN groupadd -r tomcat && useradd -r -g tomcat tomcat

# Remove default webapps and create necessary directories
RUN rm -rf /usr/local/tomcat/webapps/* && \
    mkdir -p /usr/local/tomcat/logs && \
    chown -R tomcat:tomcat /usr/local/tomcat

# Copy application
COPY --from=builder /app/target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war

# Security hardening
RUN apt-get update && \
    apt-get install -y --no-install-recommends netcat-openbsd && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Switch to non-root user
USER tomcat

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD nc -z localhost 8080 || exit 1

CMD ["catalina.sh", "run"]