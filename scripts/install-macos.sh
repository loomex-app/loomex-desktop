#!/bin/sh
set -eu

repository="loomex-app/loomex-desktop"
version="${LOOMEX_DESKTOP_VERSION:-latest}"
arch=$(uname -m)
case "$arch" in
  arm64|aarch64) asset_arch=arm64 ;;
  x86_64|amd64) asset_arch=x64 ;;
  *) echo "Unsupported macOS architecture: $arch" >&2; exit 1 ;;
esac

base="https://github.com/$repository/releases"
if [ "$version" = "latest" ]; then
  asset_base="$base/latest/download"
else
  asset_base="$base/download/desktop-v$version"
fi

asset="loomex-macos-$asset_arch.dmg"
temporary=$(mktemp -d "${TMPDIR:-/tmp}/loomex-desktop-install.XXXXXX")
cleanup() { rm -rf "$temporary"; }
trap cleanup EXIT HUP INT TERM

echo "Downloading Loomex macOS $asset_arch package..." >&2
curl --fail --location --proto '=https' --tlsv1.2 \
  "$asset_base/$asset" -o "$temporary/$asset"
curl --fail --location --proto '=https' --tlsv1.2 \
  "$asset_base/$asset.sha256" -o "$temporary/$asset.sha256"

(cd "$temporary" && shasum -a 256 -c "$asset.sha256")

mount_point=$(hdiutil attach "$temporary/$asset" -nobrowse -readonly | awk '/Apple_HFS|Apple_APFS/ {print $3; exit}')
test -n "$mount_point"
detach=1
cleanup_mount() {
  if [ "$detach" -eq 1 ]; then
    hdiutil detach "$mount_point" -quiet || true
    detach=0
  fi
}
trap 'cleanup_mount; cleanup' EXIT HUP INT TERM

app_source="$mount_point/Loomex.app"
test -d "$app_source"
echo "Installing Loomex.app into /Applications..." >&2
ditto "$app_source" "/Applications/Loomex.app"
cleanup_mount
echo "Loomex.app installed. Launch it from /Applications/Loomex.app" >&2
