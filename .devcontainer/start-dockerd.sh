#!/usr/bin/env bash
set -euo pipefail

# Start containerd if not running
if ! pgrep -x containerd >/dev/null 2>&1; then
  containerd &>/tmp/containerd.log &
  sleep 1
fi

# Start dockerd in the background and listen on unix socket and tcp:2375
# Note: listening on tcp without TLS is insecure; only used for local Codespace usage
dockerd --host=unix:///var/run/docker.sock --host=tcp://0.0.0.0:2375 &>/tmp/dockerd.log &

# Wait for docker to respond
for i in $(seq 1 30); do
  if docker version >/dev/null 2>&1; then
    break
  fi
  sleep 1
done

# Add current user to docker group if possible
if id -u "$(whoami)" >/dev/null 2>&1; then
  USERNAME=$(whoami)
  if getent group docker >/dev/null 2>&1; then
    sudo usermod -aG docker "$USERNAME" || true
  fi
fi

# Keep container running and let the devcontainer attach a shell
exec /bin/bash
