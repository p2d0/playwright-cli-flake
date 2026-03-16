#!/usr/bin/env bash
set -euo pipefail

# Fetch the latest release tag from GitHub
LATEST=$(curl -s "https://api.github.com/repos/microsoft/playwright-cli/releases/latest" \
  | grep '"tag_name"' | sed 's/.*"tag_name": *"v\([^"]*\)".*/\1/')

echo "Latest version: $LATEST"

# Compute srcHash
SRC_HASH=$(nix run nixpkgs#nix-prefetch-github -- microsoft playwright-cli --rev "v${LATEST}" --json \
  | grep '"hash"' | sed 's/.*"hash": *"\([^"]*\)".*/\1/')

echo "srcHash: $SRC_HASH"

# Fetch source tarball to get package-lock.json
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

curl -sL "https://github.com/microsoft/playwright-cli/archive/refs/tags/v${LATEST}.tar.gz" \
  | tar xz -C "$TMP"

LOCK_FILE="$TMP/playwright-cli-${LATEST}/package-lock.json"

# Compute npmDepsHash
NPM_DEPS_HASH=$(nix run nixpkgs#prefetch-npm-deps -- "$LOCK_FILE")

echo "npmDepsHash: $NPM_DEPS_HASH"

# Write versions.nix
cat > versions.nix <<EOF
{
  version = "${LATEST}";
  srcHash = "${SRC_HASH}";
  npmDepsHash = "${NPM_DEPS_HASH}";
}
EOF

echo "Done."
