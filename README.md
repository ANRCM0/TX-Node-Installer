# TX-Node Installer

Public distribution entrypoint for TX-Node deployments.

This repository intentionally contains only deployment/bootstrap material. The TX-Node application source is maintained separately, while production hosts pull the public runtime image from GHCR.

## Install

Interactive install:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/PaiMonCai/TX-Node-Installer/main/deploy.sh)
```

Non-interactive machine install (used by TXBoard):

```bash
curl -fsSL 'https://raw.githubusercontent.com/PaiMonCai/TX-Node-Installer/main/deploy.sh' \
  | sudo bash -s -- install --mode machine \
      --panel-url 'https://panel.example.com' \
      --machine-id 12 \
      --token 'MACHINE_TOKEN'
```

Optional non-interactive flags include `--kernel singbox|xray`, `--log-level`,
`--audit true|false`, and `--report-all true|false`. The non-interactive
defaults are `singbox`, `info`, audit disabled, and `report_all=false`.

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


## Legacy systemd installer

The public deployment path is the Docker-based `deploy.sh` above. The historical `install.sh` / direct binary-release path is not distributed from this repository; existing legacy installations can be imported by `deploy.sh migrate`.

## License

The deployment script follows the TX-Node project's MPL-2.0 licensing.
