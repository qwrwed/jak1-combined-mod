#!/usr/bin/env bash
set -euo pipefail
mod_build=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)
[[ -x "$mod_build/gk" && -f "$mod_build/data/out/jak1/iso/KERNEL.CGO" ]] || {
  echo 'Run this script from a completed build, not the source checkout.' >&2
  exit 1
}
# Keep personal mod settings and saves apart from the existing installations.
mod_config="${XDG_CONFIG_HOME:-$HOME/.config}/jak1-personal/jetboard"
mkdir -p -- "$mod_config"
cd -- "$mod_build"
exec ./gk --game jak1 --proj-path "$mod_build/data" --config-path "$mod_config" -- -boot "$@"
