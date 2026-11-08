> [!NOTE]
> This is a mod built on [OpenGOAL](https://github.com/open-goal/jak-project). OpenGOAL's own README, including its development environment setup, is [here](https://github.com/open-goal/jak-project/blob/v0.3.9/README.md).

# Jak 1 Combined Mod

## What it changes

Both variants:

- **Refreshed HUD:** Aloqas's Refreshed HUD 1.0 textures.
- **Skippable Sony splash:** press Start, Cross or Circle to end it.
- **Skippable title cinematic:** press Start, Cross or Circle to skip the Jak and Daxter animation into the normal village flyover.
- **Exit to Desktop:** an extra option in the pause settings menu. It uses the game's existing confirmation and shutdown, and does not save. Quit to title stays available.

The Jetboard variant also has:

- **JET-Board:** Hat Kid's JET-Board Legacy `v0.0.6` board.
- **Rigid stowed board:** the board on Jak's back is fixed rigidly to Jak's chest.
- **Hidden strap while stowed:** the loose backpack strap is hidden while the board is stowed, so it cannot clip through the board.
- **Corrected riding strap:** the strap keeps its rest pose while riding.

Both skips ignore a button already held when the scene starts. The title skip keeps the flyover and its loading intact.

## Branches

- `main` builds the Normal variant, based on OpenGOAL `v0.3.9`.
- `jetboard` builds the Jetboard variant. It derives from `main` and adds the board.

## Install through the OpenGOAL Launcher

Add this Mod Source URL in the launcher under **Settings → Mods**:

```text
https://raw.githubusercontent.com/qwrwed/jak1-combined-mod/main/mods.json
```

On the Jak 1 page, open **Features → Mods** and install either **Jak 1 Combined Mod (Normal)** or **Jak 1 Combined Mod (Jetboard)**. The source currently provides Linux x86-64 builds. The two variants use separate launcher settings and save directories.

For an existing Steam shortcut, use the installed mod's `gk` and working directory. The mod page's copied launch command supplies the matching options and settings path. Keep the existing Steam entry when updating its fields.

## Build on an x86-64 Linux machine

For `main`, build `gk` from this branch, since the splash skip is in the runtime; OpenGOAL v0.3.9's `goalc` and `extractor` work unchanged. For `jetboard`, build `gk`, `goalc` and `extractor` from this branch: its compiler includes the board sound-bank builder. The original board release's compiler cannot compile the newer base. The helper uses these executables to compile the GOAL sources and rebuild assets with the bundled HUD textures.

```bash
bash personal-mod/build.sh /path/to/matching/tools /path/to/extracted/jak1 /path/to/new/build
```

`TOOLS_DIR` contains `gk`, `goalc`, and `extractor`. The extracted Jak 1 directory contains the original game files and `buildinfo.json`. Build into a new folder; the script refuses an existing output path. Original extracted files are read through a symlink; generated files go into the new build only. Keep the original extracted directory available. This is a local build, not a portable release.

For a compiler-only check, append `--code-only`. That verifies GOAL compilation but does not produce a playable game or verify textures and in-game behavior.

## Launcher package

Package this branch's sources and its matching executables with:

```bash
bash personal-mod/package.sh /path/to/matching/tools /path/to/new/archive.tar.gz
```

The archive contains `gk`, `goalc`, `extractor`, and the source, configuration, shader and custom asset inputs under `data/`. The Launcher uses the user's extracted game to decompile and compile the mod during installation. Original game data, generated levels/audio, saves and standalone launch wrappers are excluded. Archives are not committed.

## Shared changes

Keep shared changes on `main` and merge them into `jetboard`. The board branch inherits those commits directly and adds its board code, assets, sound-bank builder and attachment fix.

## Credits and provenance

- [OpenGOAL](https://github.com/open-goal/jak-project) `v0.3.9`: the base engine, compiler and tools for both branches.
- Aloqas's [Refreshed HUD](https://github.com/Aloqas/Jak-1-Refreshed-HUD) `1.0`, used by both branches:
  - Asset: `Jak-1-Refreshed-HUD-1.0.zip`, standard PlayStation button artwork.
  - SHA-256: `e3ccefffe8d705a6bbdd9fe3dfb0eb9c30eb4bfb109330d60e3764f3c761d74c`.
  - The PNGs are imported unchanged into `custom_assets/jak1/texture_replacements`.
- Hat Kid's [JET-Board Legacy](https://github.com/Hat-Kid/og-j1-board) `v0.0.6`, used by `jetboard` only:
  - The board code, assets and sound-bank builder are ported onto the `main` base.
  - The stowed-board attachment and strap fixes are changes made in this repo.

Personal use. No original game assets or generated game files are committed.
