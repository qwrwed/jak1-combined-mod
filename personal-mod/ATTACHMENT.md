# Rigid stowed-board attachment

This change is on the `jetboard` branch only.

The riding path continues to read joint 47 from the board animation skeleton.
When Jak uses his normal skeleton, the stowed board now follows chest joint 5
instead of the animated backpack-strap joint 67.

A bare joint swap would lose the board's position and orientation relative to
Jak's back. Instead, the code derives a fixed chest-to-strap transform from the
normal skeleton's reference pose:

```text
fixed offset = chest inverse-bind × inverse(strap inverse-bind)
board world transform = animated chest world transform × fixed offset
```

This preserves the strap attachment's reference position and angle, but never
reads the strap's animated transform. The offset does not depend on which frame
Jak is in when the board is put away. Board scaling remains on the existing
path, and the riding joint and boarding animations are unchanged.

`joint.bind-pose` stores inverse-bind matrices in this engine; this convention
is also used by `decompiler/level_extractor/fr3_to_gltf.cpp` to reconstruct local
joint transforms. All offset data comes from the installed character skeleton;
there are no guessed positional or angular constants.

`personal-mod/tests/stowed-board.gc` checks the actual GOAL matrix helper against
a known reference attachment and six rotated/translated torso poses. It also
checks that the fixture detects a reversed bind relationship. The test is loaded
into an isolated runtime through its compiler listener; it does not modify an
installed game or save.

To repeat the native test, start the new build with `-boot -debug-mem -nosound`
and `--no-display`, using a temporary `--config-path`. Its matching compiler can
then run:

```lisp
(begin
  (make-group "all-code")
  (lt 8112)
  (asm-file "/absolute/path/to/personal-mod/tests/stowed-board.gc" :color :load))
```

Use a separate test process with its matching compiler and runtime; do not
attach to a running personal game session.

The reference placement is preserved; matching Jak 2/3's appearance exactly
would require a separate placement adjustment.
