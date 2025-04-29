#!/bin/bash

# Resolve the script location (in case of symlinks)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENTRY="$SCRIPT_DIR/kubenu.nu"

# Ensure Nushell is installed
if ! command -v nu >/dev/null 2>&1; then
  echo "❌ Nushell (nu) is not installed. Please install it from https://www.nushell.sh"
  exit 1
fi

# Pass all arguments to the Nushell script
exec nu -f "$ENTRY" -- "$@"
