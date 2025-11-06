# NextGen Farmers Hub - ERPNext Custom Dockerfile
FROM frappe/erpnext:v14

# Set build arguments
ARG FRAPPE_VERSION=version-14
ARG ERPNEXT_VERSION=version-14

USER root

# Install additional dependencies
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    vim \
    git \
    && rm -rf /var/lib/apt/lists/*

# Switch to frappe user
USER frappe

# Set working directory
WORKDIR /home/frappe/frappe-bench

# Install Agriculture app (optional dependency)
RUN bench get-app --branch ${FRAPPE_VERSION} agriculture https://github.com/frappe/agriculture.git || true

# Copy NextGen Farmers app
COPY --chown=frappe:frappe . apps/nextgen_farmers/

# Install NextGen Farmers app
RUN cd apps/nextgen_farmers && \
    pip3 install -e . && \
    cd ../..

# Build assets
RUN bench build --app nextgen_farmers || true

# Create entrypoint script
USER root
COPY docker/scripts/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

USER frappe

EXPOSE 8000 9000

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["bench", "start"]
