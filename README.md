# vm11

This repository contains a devcontainer that starts containerd + dockerd so you can run Docker inside a Codespace.

To use:
1. Open this repository in a Codespace (GitHub → Code → Codespaces → New codespace) or use gh CLI.
2. Choose the default branch (main). The devcontainer will build and start dockerd automatically.
3. In the Codespace terminal run:
   docker --version
   docker run --rm hello-world

Caveats:
- Some privileged Docker features may not work inside Codespaces. If dockerd fails to start, consider using a remote Docker host and `docker context` instead.
