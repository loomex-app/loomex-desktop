# loomex-desktop

Cross-platform Loomex desktop application and native desktop runner.

This repository owns the Tauri UI, desktop runner lifecycle, local IPC,
workspace/process integration, and macOS/Windows/Linux packaging. It does not
own Codex marketplace packaging or MCP stdio transport.

The current migration snapshot keeps the existing `loomex-core` implementation
while the stable shared contracts move to `loomex-protocol`.

## Install on macOS

The release workflow publishes separate unsigned DMGs for Apple Silicon and
Intel Macs. The simplest installation is:

```bash
curl -fsSL https://github.com/loomex-app/loomex-desktop/releases/latest/download/install-macos.sh | sh
```

The installer downloads the architecture-matched DMG, verifies its SHA-256
checksum, mounts it, and copies `Loomex.app` to `/Applications`.

To install an exact version, set `LOOMEX_DESKTOP_VERSION` to the version without
the `desktop-v` prefix:

```bash
curl -fsSL \
  https://github.com/loomex-app/loomex-desktop/releases/download/desktop-v0.1.21/install-macos.sh \
  | LOOMEX_DESKTOP_VERSION=0.1.21 sh
```

The current build is unsigned, so macOS may require Finder's **Open** action
once to approve it in Gatekeeper. Developer ID signing and notarization should
be added before broad production distribution.
