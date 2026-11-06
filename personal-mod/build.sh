#!/usr/bin/env bash
# Build into a new directory; never write into the supplied installation.
set -euo pipefail

if [[ $# -lt 3 || $# -gt 4 || (${4:-} != '' && ${4:-} != --code-only) ]]; then
  echo 'Usage: bash personal-mod/build.sh TOOLS_DIR EXTRACTED_JAK1_DIR NEW_BUILD_DIR [--code-only]' >&2
  exit 2
fi

mod_repo=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)
mod_tools=$(realpath -e -- "$1")
mod_iso=$(realpath -e -- "$2")
mod_output=$(realpath -m -- "$3")

for mod_binary in gk goalc extractor; do
  [[ -x "$mod_tools/$mod_binary" ]] || { echo "Missing executable: $mod_tools/$mod_binary" >&2; exit 1; }
done
[[ -f "$mod_iso/buildinfo.json" ]] || { echo 'Expected an already extracted Jak 1 folder with buildinfo.json.' >&2; exit 1; }
[[ ! -e "$mod_output" ]] || { echo "Build directory already exists: $mod_output" >&2; exit 1; }

mkdir -p -- "$mod_output/data/game/graphics/opengl_renderer" "$mod_output/data/decompiler" \
  "$mod_output/data/iso_data" "$mod_output/data/log"
cp -- "$mod_tools/gk" "$mod_tools/goalc" "$mod_tools/extractor" "$mod_output/"
cp -a -- "$mod_repo/goal_src" "$mod_repo/custom_assets" "$mod_output/data/"
cp -a -- "$mod_repo/decompiler/config" "$mod_output/data/decompiler/"
cp -a -- "$mod_repo/game/assets" "$mod_output/data/game/"
cp -a -- "$mod_repo/game/graphics/opengl_renderer/shaders" "$mod_output/data/game/graphics/opengl_renderer/"
# The extractor/compiler reads original assets through this link. Outputs stay here.
ln -s -- "$mod_iso" "$mod_output/data/iso_data/jak1"
cp -a -- "$mod_repo/personal-mod" "$mod_output/personal-mod"

cd -- "$mod_output"
if [[ ${4:-} == --code-only ]]; then
  ./goalc --game jak1 --proj-path "$mod_output/data" --disable-ansi \
    --cmd '(make-group "all-code")' 2>&1 | tee build.log
else
  ./extractor --game jak1 --proj-path "$mod_output/data" --disable-ansi \
    --folder --decompile --compile "$mod_iso" 2>&1 | tee build.log
  printf '%s\n' 'Build complete. Launch with: bash personal-mod/launch.sh'
fi
