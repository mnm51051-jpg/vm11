#!/usr/bin/env bash
set -euo pipefail

LOG=/tmp/start-dockerd.log
echo "[start-dockerd] $(date) - starting" > "$LOG"

# Start containerd if not already running
if ! pgrep -x containerd >/dev/null 2>&1; then
  echo "[start-dockerd] starting containerd..." >> "$LOG"
  nohup containerd >> "$LOG" 2>&1 &
  sleep 1
fi

# Start dockerd if not already running
if ! pgrep -x dockerd >/dev/null 2>&1; then
  echo "[start-dockerd] starting dockerd..." >> "$LOG"
  # Bind docker TCP to localhost only for safety inside Codespace
  nohup dockerd --host=unix:///var/run/docker.sock --host=tcp://127.0.0.1:2375 >> "$LOG" 2>&1 &
fi

# Wait for docker to become responsive
for i in $(seq 1 30); do
  if docker version >/dev/null 2>&1; then
    echo "[start-dockerd] dockerd responsive" >> "$LOG"
    break
  fi
  sleep 1
done

# Add current user to docker group if it exists (allows non-sudo docker)
CURRENT_USER="$(whoami)"
if getent group docker >/dev/null 2>&1; then
  echo "[start-dockerd] adding $CURRENT_USER to docker group" >> "$LOG"
  sudo usermod -aG docker "$CURRENT_USER" || true
fi

echo "[start-dockerd] done" >> "$LOG"
exit 0
