# TX-Node Installer

Public distribution entrypoint for TX-Node deployments.

This repository intentionally contains only deployment/bootstrap material. The TX-Node application source is maintained separately, while production hosts pull the public runtime image from GHCR.

## Install

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/PaiMonCai/TX-Node-Installer/main/deploy.sh)
```

After installation, use:

```bash
txnode
```

The runtime image defaults to:

```text
ghcr.io/paimoncai/tx-node:latest
```

## Architecture

```text
TX-Node source repository
        |
        | GitHub Actions / image publishing
        v
ghcr.io/paimoncai/tx-node (public)
        ^
        | docker pull / upgrade
        |
TX-Node-Installer (public deploy.sh)
        ^
        | curl
        |
      server
```

The installer repository must not contain TX-Node application source, private credentials, tokens, or production configuration.
