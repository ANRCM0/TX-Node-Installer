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


## Multi-panel hosts

If the server already has a Docker TX-Node deployment, running the installer again no longer overwrites the existing configuration by default.

Interactive mode offers:

- **Add panel / instance** — recommended. The current single-panel config is preserved and converted to `instances:` when necessary, then the new Node or Machine target is appended.
- **Create isolated TX-Node** — creates `tx-node-2`, `/etc/txnode-2`, `/usr/local/bin/txnode-2`, then `tx-node-3`, and so on. Each isolated profile gets its own health port.
- **Overwrite current deployment** — explicit destructive reconfiguration for cases where replacement is actually intended.

The TXBoard non-interactive command is additive as well. If `install --mode machine|node ...` is run on a host that already has TX-Node, the supplied Panel + Machine/Node target is appended as a new instance. An identical target is treated as an idempotent no-op.

After installation, the same flows are available through:

```bash
txnode panel-add
txnode isolated-add
```

Before adding an instance, the installer backs up the existing config. It validates the restarted container, checks the configured health endpoint and obvious bind conflicts, and restores the previous config if the new instance cannot start cleanly.

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
