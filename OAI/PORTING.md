# Toolchain and provenance notes

## Palomar module-system port

The submission pins **Lean `v4.35.0-rc2`** and Mathlib
`065356127b1dc0016f66b7283ce0ce2c4055aa55`. All repository Lean sources have
module headers, public imports, and exposed public interfaces. Existing private
modifiers and attribution are retained. The `backward.privateInPublic` and
`backward.proofsInPublic` compatibility options preserve pre-module elaboration;
they do not introduce mathematical axioms or disable kernel checking.

Two former `deriving Encodable` sites needed a module-boundary repair:
`Computability/OracleCode.lean` and `SetModels/ElementaryLanguage.lean` now use
explicit finite-tree encodings and proved decoding round trips. The helper
`Effective/EncodableTree.lean` adapts Kyle Miller's Apache-2.0 Mathlib
`DeriveEncodable` implementation and retains its attribution. Constructor tags
and list layout match the former deriving scheme. The types of oracle programs,
formulas, and their mathematical operations are unchanged.

The independent `Challenge.lean` imports only Mathlib and reproduces the
ordinary degree quotient, order, concrete join, and computable bottom. Including
the join instance makes the inherited order instance match exactly across the
Challenge and Solution environments. `Solution.lean` exports the original cone
theorem. Comparator and the transitive axiom audits are the verification gates.

A successful old-toolchain build is not by itself evidence for the new port.
Consult the checks at the submitted immutable commit. The primary target checks
Challenge, Solution, and the cone proof's complete dependency closure; it is not
a claim that every unrelated historical target was rebuilt.

## Verified upstream origin

Before this port, `OAI/Computability/DegreeRigidity` was an unmodified copy of:

<https://github.com/openai/math/tree/fd4aeeb2ee4fc729c18d98444fed42fd0529eeeb/lean/OAI/Computability/DegreeRigidity>

That directory and the inherited directory at local commit
`b934186a456258a055de59689e75b1d503f3c71f` share the Git tree hash
`d979299cdac872372c8c2893b287ebf89fbb9258`. The license is Apache-2.0.
The module-system and codec repairs are local modifications, so the current
directory is no longer claimed to be byte-for-byte identical to upstream.

## Historical Lean 4.34.1 port

Before Palomar packaging, the original project notes recorded a successful
`lake build RequestProject OAI` on Lean `v4.34.1` and Mathlib
`d13f23b723b8a846827a245b89c10fc7d3f11612`, the upstream DegreeRigidity pins.
An earlier backport to `v4.28.0` had been removed: the Compat shim,
recursive-computability renames, import/attribute backports, and approximately
25 proof repairs were no longer needed.

The earlier truth-table development under `RequestProject/TT/` was also ported
from `v4.28.0` to `v4.34.1`. Its recorded changes, without changed theorem
statements or added unproved assumptions, were:

- Mark `Z2` as `@[implicit_reducible]` for its oracle type synonym while
  preserving the distinction between 2-adic and pointwise addition.
- Add explicit `rfl` after selected `simp only` calls in Defs and Uniform.
- Remove no-longer-needed `dsimp only` steps in Cantor, Degrees, and DecodeTools.
- Use explicit cons rewrites in a filterMap identity proof in Closure.
- Replace one final `simpa` in Prop31 by `simp at this; exact this`.
- Update deprecated conditional, set, topology, and tactic names for Lean 4.34.

The historical notes reported only `propext`, `Classical.choice`, and
`Quot.sound` in those theorem audits. The present Palomar entry advertises the
cone theorem, whose current CI and Comparator checks are separately specified
at the repository root.
