# Rigid stowed-board attachment

This change is on the `jetboard` branch only.

The riding path continues to read joint 47 from the board animation skeleton.
When Jak uses his normal skeleton, the stowed board now follows chest joint 5
instead of the animated backpack-strap joint 67.

A bare joint swap would lose the attachment point. The code derives a fixed
chest-to-strap transform from the normal skeleton's reference pose:

```text
reference offset = inverse(strap inverse-bind) × chest inverse-bind
board world transform = flat reference offset × animated chest world transform
```

These equations follow the engine's row-vector convention: local transforms
compose before parent/world transforms. The reference offset preserves the
attachment position, but its original rotation points the board out from the
back. The stowed board's deck is in model XZ, its long axis is +Z, and its
broad-face normal is +Y. To lay it flat while preserving the diagonal:

1. Project the reference long-axis row into the chest's XY back plane and normalize it.
2. Map the board's +Y face normal to chest +Z, putting the underside outward.
3. Reconstruct the width as face-normal cross long-axis, retaining a right-handed basis.
4. Keep the reference translation and then compose with the animated chest transform.

The code never reads the strap's animated transform. The attachment does not
depend on the frame when the board is put away. Board scaling remains on the
existing path, and the riding joint and boarding animations are unchanged.

`joint.bind-pose` stores inverse-bind matrices in this engine; this convention
is also used by `decompiler/level_extractor/fr3_to_gltf.cpp` to reconstruct local
joint transforms. All offset data comes from the installed character skeleton;
there are no guessed positional offsets or fixed rotation angles.

`personal-mod/tests/stowed-board.gc` checks the actual GOAL matrix helper against
a tilted reference attachment and an independently specified analytic flat
orientation, then six rotated/translated torso poses. It checks the desired
face, preserved diagonal and attachment position, rejects the original outward
tilt, and detects a reversed bind relationship. Expected animated matrices are
built by independently transforming the four analytic target rows.
These numeric checks do not establish visual correctness with real assets.
The test is loaded
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

For live iteration in a separate test session, keep the compiler connected for
the comparison cycle. Normal compiler exit resets the game; this runtime's
DECI2 server does not accept a replacement client after an abrupt disconnect.
Wait for the version handshake and load acknowledgement before capturing a
changed state. A single-function `asm-file ... :load` override is useful for a
temporary preview; save the source and rebuild the game archive before claiming
the change will survive relaunch.

While the board prop is present on the normal character skeleton, a joint
callback collapses the loose backpack strap's scale at joint 67. This hides
the strap that otherwise animates through the board's circular centre. The
normal animation supplies a fresh pose each frame; when the prop is absent,
the callback leaves that pose unchanged. The separate riding skeleton keeps
its strap animation. This does not move or rotate the board.

## Explicit-root actor import

The Legacy board, rider and sidekick GLBs already contain their `align` and
`prejoint` roots. The actor builder must preserve those indices rather than
prepend another align joint. Geometry joints and animation channels use the
same conditional prefix count. This keeps the board at node 47 and aligns
skin weights with their intended bones. Models without an explicit align root
retain the base importer's existing behavior.
