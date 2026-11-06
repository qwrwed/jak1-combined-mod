#!/usr/bin/env bash
set -euo pipefail
if [[ $# != 2 ]]; then
  echo 'Usage: bash personal-mod/package.sh COMPLETED_BUILD NEW_ARCHIVE.tar.gz' >&2
  exit 2
fi
mod_build=$(realpath -e -- "$1")
mod_archive=$(realpath -m -- "$2")
[[ ! -e "$mod_archive" ]] || { echo "Archive already exists: $mod_archive" >&2; exit 1; }
[[ -f "$mod_build/data/out/jak1/iso/KERNEL.CGO" ]] || { echo 'Not a completed game build.' >&2; exit 1; }
mod_partial=$(mktemp -- "$mod_archive.partial.XXXXXX")
trap 'rm -f -- "$mod_partial"' EXIT
# Runtime assets only: no extracted ISO, saves, build logs, or source checkout.
tar -czf "$mod_partial" -C "$mod_build" \
  gk personal-mod/launch.sh data/out/jak1/iso data/out/jak1/fr3 \
  data/game/assets data/game/graphics/opengl_renderer/shaders data/goal_src/user
gzip -t -- "$mod_partial"
mv -- "$mod_partial" "$mod_archive"
printf 'Saved %s\n' "$mod_archive"
