#!/usr/bin/env bash
set -euo pipefail
if [[ $# != 2 ]]; then
  echo 'Usage: bash personal-mod/package.sh MATCHING_TOOLS_DIR NEW_ARCHIVE.tar.gz' >&2
  exit 2
fi
mod_repo=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)
mod_tools=$(realpath -e -- "$1")
mod_archive=$(realpath -m -- "$2")
[[ ! -e "$mod_archive" ]] || { echo "Archive already exists: $mod_archive" >&2; exit 1; }
for mod_binary in gk goalc extractor; do
  [[ -x "$mod_tools/$mod_binary" ]] || { echo "Missing executable: $mod_tools/$mod_binary" >&2; exit 1; }
done
mod_stage=$(mktemp -d -- "$(dirname -- "$mod_archive")/.mod-package.XXXXXX")
mod_partial=$(mktemp -- "$mod_archive.partial.XXXXXX")
trap 'rm -rf -- "$mod_stage"; rm -f -- "$mod_partial"' EXIT
# The Launcher decompiles and compiles using this package's matching tools.
# Ship source inputs, never extracted ISO contents or generated game data.
mkdir -p -- "$mod_stage/data/decompiler" "$mod_stage/data/game/graphics/opengl_renderer"
cp -- "$mod_tools/gk" "$mod_tools/goalc" "$mod_tools/extractor" "$mod_stage/"
cp -a -- "$mod_repo/goal_src" "$mod_repo/custom_assets" "$mod_stage/data/"
cp -a -- "$mod_repo/decompiler/config" "$mod_stage/data/decompiler/"
cp -a -- "$mod_repo/game/assets" "$mod_stage/data/game/"
cp -a -- "$mod_repo/game/graphics/opengl_renderer/shaders" "$mod_stage/data/game/graphics/opengl_renderer/"
tar --sort=name --owner=0 --group=0 --numeric-owner --format=posix \
  --pax-option=delete=atime,delete=ctime -czf "$mod_partial" -C "$mod_stage" \
  gk goalc extractor data
gzip -t -- "$mod_partial"
mv -- "$mod_partial" "$mod_archive"
printf 'Saved %s\n' "$mod_archive"
