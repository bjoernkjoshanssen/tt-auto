# Toolchain and provenance notes

## Palomar port

The Palomar submission branch uses **Lean `v4.35.0-rc2`** and matching Mathlib
`065356127b1dc0016f66b7283ce0ce2c4055aa55`. See the CI results at the submitted
commit for verification; a prior-toolchain build alone does not validate this port.

All repository Lean sources have been migrated to the module system: `module`
headers, public imports, and `@[expose] public section`. Explicit private
modifiers and existing attribution are retained. The compatibility options
`backward.privateInPublic` and `backward.proofsInPublic` preserve pre-module
elaboration; they do not add axioms or disable kernel checking. The two
`deriving Encodable` sites explicitly import all of the deriving module so its
private helper representation is available during elaboration.

The independent `Challenge.lean` imports only Mathlib and repeats the elementary
Turing-degree definitions. `Solution.lean` exports the original cone theorem.
Comparator and the transitive axiom audits are the verification gates.

## Verified upstream origin

Before the Palomar port, `OAI/Computability/DegreeRigidity` was an unmodified copy
of the library at:

<https://github.com/openai/math/tree/fd4aeeb2ee4fc729c18d98444fed42fd0529eeeb/lean/OAI/Computability/DegreeRigidity>

The directory at local commit `b934186a456258a055de59689e75b1d503f3c71f` and the
upstream directory have the identical Git tree hash
`d979299cdac872372c8c2893b287ebf89fbb9258`. Its license is Apache-2.0. The module
visibility port is a local modification, so the current directory is no longer
claimed to be byte-for-byte identical to that upstream snapshot.

## Historical Lean 4.34.1 port

Before Palomar packaging, the whole project built with Lean `v4.34.1` and Mathlib
`d13f23b723b8a846827a245b89c10fc7d3f11612`, the versions pinned by the upstream
DegreeRigidity library. The pre-Palomar notes recorded a successful
`lake build RequestProject OAI` without warnings. This historical statement is
not a claim that every unrelated target has been rebuilt on the new toolchain.

An earlier local backport of the OAI library to `v4.28.0` was removed when the
project moved to `v4.34.1`: the Compat shim, recursive-computability renames,
import/attribute backports, and approximately 25 local proof repairs were no
longer needed.

The earlier truth-table development in `RequestProject/TT/` was itself ported
from `v4.28.0` to `v4.34.1`, without changing theorem statements or adding
unproved assumptions. Its recorded changes were:

- Mark `Z2` as `@[implicit_reducible]` so its oracle type synonym unfolds at
  implicit transparency without mixing its 2-adic addition with pointwise
  addition during instance search.
- Add explicit `rfl` after selected `simp only` calls in Defs and Uniform.
- Remove no-longer-needed `dsimp only` steps in Cantor, Degrees, and DecodeTools.
- Replace a filterMap identity proof in Closure with explicit cons rewrites.
- Replace one final `simpa` in Prop31 with `simp at this; exact this`.
- Update deprecated conditional, set, topology, and tactic names for Lean 4.34.

The original notes reported only `propext`, `Classical.choice`, and `Quot.sound`
in those theorem audits. The present Palomar entry advertises the cone theorem;
its CI and Comparator checks are separately specified at the repository root.
