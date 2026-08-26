FROM mcr.microsoft.com/devcontainers/base:ubuntu

# Install minimal dependencies and Docker components
RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    apt-transport-https ca-certificates curl gnupg lsb-release iproute2 gnupg2 \
  && mkdir -p /etc/apt/keyrings \
  && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
     > /etc/apt/sources.list.d/docker.list \
  && apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y docker-ce-cli containerd \
  && rm -rf /var/lib/apt/lists/*

# Add a script to start containerd + dockerd in the container
COPY start-dockerd.sh /usr/local/bin/start-dockerd.sh
RUN chmod +x /usr/local/bin/start-dockerd.sh

# Make docker group (ensure non-root devuser can be added later)
RUN groupadd -g 999 docker || true

CMD ["/usr/local/bin/start-dockerd.sh"]
