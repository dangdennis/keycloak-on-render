FROM quay.io/keycloak/keycloak:latest

# Enable health and metrics support
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true

# Configure a database vendor
ENV KC_DB=postgres

WORKDIR /opt/keycloak
# Generate a self-signed certificate for demonstration purposes
RUN keytool -genkeypair -storepass password -storetype PKCS12 -keyalg RSA -keysize 2048 -dname "CN=server" -alias server -ext "SAN:c=DNS:localhost,IP:127.0.0.1" -keystore conf/server.keystore
RUN /opt/keycloak/bin/kc.sh build

# Ensure the script is executable
RUN chmod +x /opt/keycloak/bin/kc.sh

# Environment variables for database configuration
ENV KC_DB=${KC_DB}
ENV KC_DB_URL=${KC_DB_URL}
ENV KC_DB_USERNAME=${KC_DB_USERNAME}
ENV KC_DB_PASSWORD=${KC_DB_PASSWORD}
ENV KC_HOSTNAME=${KC_HOSTNAME}
ENV KC_HOSTNAME_PORT=10000

# Expose the required port for Render
EXPOSE 10000

# Set the working directory to where the kc.sh script is located
WORKDIR /opt/keycloak/bin

CMD ["./kc.sh", "start-dev"]