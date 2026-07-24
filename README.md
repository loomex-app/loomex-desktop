# loomex-desktop

Cross-platform Loomex desktop application and native desktop runner.

This repository owns the Tauri UI, desktop runner lifecycle, local IPC,
workspace/process integration, and macOS/Windows/Linux packaging. It does not
own Codex marketplace packaging or MCP stdio transport.

The current migration snapshot keeps the existing `loomex-core` implementation
while the stable shared contracts move to `loomex-protocol`.
