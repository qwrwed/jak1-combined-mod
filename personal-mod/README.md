# Jak 1 personal mod

Two local branches produce separately launchable builds:

- `main`: normal Jak 1 gameplay, based on OpenGOAL `v0.3.9`.
- `jetboard`: derives from `main`, adding the JET-Board Legacy `v0.0.6` board
  and a rigid attachment for the board stowed on Jak's back.

Both include Aloqas's Refreshed HUD 1.0, a Start/Circle/Cross skip for the
Jak and Daxter title animation into the normal village flyover, and an
additional **Exit to Desktop** option in the pause settings menu. The existing
quit-to-title action stays available. Exit uses the existing confirmation and
shutdown handler; it does not perform a new manual save.

The title skip waits for the previous skip button to be released first. Its
callback uses the engine's existing spooled-animation cleanup; the flyover and
its loading commands remain intact.

## Build on an x86-64 Linux machine

Use OpenGOAL v0.3.9 executables for `main`. For `jetboard`, build `gk`, `goalc`
and `extractor` from this branch: its compiler includes the board sound-bank
builder. The original board release's compiler cannot compile the newer base.
The helper uses these executables to compile the GOAL sources and rebuild
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

Keep shared changes on `main` and merge them into `jetboard`. The board branch
inherits those commits directly and adds its board code, assets, sound-bank
builder and attachment fix.

## HUD provenance

- Source: https://github.com/Aloqas/Jak-1-Refreshed-HUD
- Release: `1.0`, standard PlayStation button artwork.
- Asset: `Jak-1-Refreshed-HUD-1.0.zip`.
- SHA-256: `e3ccefffe8d705a6bbdd9fe3dfb0eb9c30eb4bfb109330d60e3764f3c761d74c`.
- The PNGs are imported unchanged into `custom_assets/jak1/texture_replacements`.

Personal use. No original game assets or generated game files are committed.

## Install through the OpenGOAL Launcher

Add this Mod Source URL in the launcher under **Settings → Mods**:

```text
https://raw.githubusercontent.com/qwrwed/jak1-combined-mod/main/mods.json
```

On the Jak 1 page, open **Features → Mods** and install either **Jak 1
Combined Mod (Normal)** or **Jak 1 Combined Mod (Jetboard)**. The source
currently provides Linux x86-64 builds. The two variants use separate
launcher settings and save directories.

## Standalone runtime archive

After a full build, a runtime archive can also be made with:

```bash
bash personal-mod/package.sh /path/to/completed/build /path/to/new/archive.tar.gz
```

This includes the executable, compiled levels/audio, HUD, and launch script.
The OpenGOAL Launcher installs its release archives directly. For standalone
use, extract an archive into a new folder on an x86-64 Linux device and run
`bash personal-mod/launch.sh` there. It does not depend on the original
extracted ISO directory. Archives are not committed.
