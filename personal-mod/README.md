# Jak 1 personal mod

Two local branches produce separately launchable builds:

- `main`: normal Jak 1 gameplay, based on OpenGOAL `v0.3.9`.
- `jetboard`: JET-Board Legacy `v0.0.6` plus the shared personal changes.

Both include Aloqas's Refreshed HUD 1.0, a Start/Circle/Cross skip for the
Jak and Daxter title animation into the normal village flyover, and an
additional **Exit to Desktop** option in the pause settings menu. The existing
quit-to-title action stays available. Exit uses the existing confirmation and
shutdown handler; it does not perform a new manual save.

The title skip waits for the previous skip button to be released first. Its
callback uses the engine's existing spooled-animation cleanup; the flyover and
its loading commands remain intact.

## Build on an x86-64 Linux machine

Use the matching release's executables: OpenGOAL v0.3.9 for `main`, or JET-Board
Legacy v0.0.6 for `jetboard`. The build does not need C++ compilation. It uses
the supplied `goalc` and `extractor` to compile the GOAL sources and rebuild
assets with the bundled HUD textures.

```bash
bash personal-mod/build.sh /path/to/matching/tools /path/to/extracted/jak1 /path/to/new/build
bash /path/to/new/build/personal-mod/launch.sh
```

`TOOLS_DIR` contains `gk`, `goalc`, and `extractor`. The extracted Jak 1 directory
contains the original game files and `buildinfo.json`. Build into a new folder;
the script refuses an existing output path. Original extracted files are read
through a symlink; generated files go into the new build only. Keep the original
extracted directory available. This is a local build, not a portable release.

For a compiler-only check, append `--code-only`. That verifies GOAL compilation
but does not produce a playable game or verify textures and in-game behavior.

The launch scripts use separate config directories under
`~/.config/jak1-personal/normal` and `~/.config/jak1-personal/jetboard`, respectively.
They do not import or modify existing saves.

## Shared changes

JET-Board uses its own older OpenGOAL toolchain and custom model/animation
pipeline. Keep its release source as its base. Apply shared feature commits
from `main` with `git cherry-pick`; do not merge the entire newer upstream
release into the older mod without reviewing compatibility.

## HUD provenance

- Source: https://github.com/Aloqas/Jak-1-Refreshed-HUD
- Release: `1.0`, standard PlayStation button artwork.
- Asset: `Jak-1-Refreshed-HUD-1.0.zip`.
- SHA-256: `e3ccefffe8d705a6bbdd9fe3dfb0eb9c30eb4bfb109330d60e3764f3c761d74c`.
- The PNGs are imported unchanged into `custom_assets/jak1/texture_replacements`.

Personal use. No original game assets or generated game files are committed.

## Runtime archive

After a full build, make a personal runtime archive with:

```bash
bash personal-mod/package.sh /path/to/completed/build /path/to/new/archive.tar.gz
```

This includes the executable, compiled levels/audio, HUD, and launch script.
Extract it into a new folder on an x86-64 Linux gaming device and run
`bash personal-mod/launch.sh` there. Unlike the build directory, this archive
does not depend on the original extracted ISO directory. It is not committed.
