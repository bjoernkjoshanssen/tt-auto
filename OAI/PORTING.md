# Toolchain notes

The whole project now builds with **Lean `v4.34.1`** and **Mathlib
`d13f23b723b8a846827a245b89c10fc7d3f11612`**. These are the same versions that the upstream
`DegreeRigidity` library pins. `lake build RequestProject OAI` succeeds without warnings.

## `OAI/Computability/DegreeRigidity`

This directory is an **unmodified copy** of the `DegreeRigidity` library from
<https://github.com/openai/math/tree/main/lean/OAI/Computability/DegreeRigidity>
(commit `fd4aeeb2ee4fc729c18d98444fed42fd0529eeeb`, Apache-2.0, see `LICENSE`). Every file is
byte-for-byte identical to upstream.

An earlier version of this project back-ported the library to Lean/Mathlib `v4.28.0`. All of
that work has been removed, because it is no longer needed:

* the `Compat.lean` shim file;
* renaming `Nat.RecursiveIn` to `RecursiveIn`;
* the import rename and the `@[instance_reducible]` → `@[reducible]` change;
* the roughly 25 local proof repairs.

## `RequestProject`

The tt-degree development in `RequestProject/TT/` was written against `v4.28.0`. It has been
ported forward to `v4.34.1`. **No definition or theorem statement was changed, and no `sorry`,
`axiom` or other unproved assumption was added.** `#print axioms` on the main theorems still
shows only `propext`, `Classical.choice` and `Quot.sound`. The changes are:

* **`Z2` is marked `@[implicit_reducible]`** (`TwoAdic.lean`). `Z2` is a type synonym for
  `Oracle` that carries the 2-adic group structure. Since Lean 4.34, `isDefEq` checks implicit
  arguments, and the types of metavariable assignments, at the `implicit` transparency level.
  That level no longer unfolds ordinary definitions, so terms such as `trunc X` with `X : Z2`
  stopped unifying with lemmas stated for `Oracle`. The new `implicit_reducible` attribute
  lets `Z2` unfold at that level. It still does not unfold during instance search, so the
  2-adic `+` on `Z2` stays separate from Mathlib's pointwise `+` on `ℕ → Bool`.
* **`simp only` no longer closes some goals by `rfl`.** These are goals whose two sides agree
  only up to unfolding, such as `OracleCode.eval` or `Nat.unpaired`. An explicit `rfl` was
  added after the `simp only` (`Defs.lean`, `Uniform.lean`).
* **Unneeded `dsimp only` steps removed.** These were added for `v4.28.0`, where goals stayed
  as beta-redexes. Lean now beta-reduces them automatically, so `dsimp only` made no progress
  and failed (`Cantor.lean`, `Degrees.lean`, `DecodeTools.lean`).
* **`simp` now rewrites `id` to `fun x => x`.** This broke `filterMap_id_map_some`, which is now
  proved with explicit `List.filterMap_cons_none` / `List.filterMap_cons_some` rewrites
  (`Closure.lean`).
* **One `simpa` changed to `simp at this; exact this`.** The final step needs to unfold
  `Z2.of` at default transparency (`Prop31.lean`).
* **Deprecation renames:**
  * `if_pos` → `ite_eq_left`, `if_true` → `ite_true`, `if_false` → `ite_false`,
    `dif_neg` → `dite_eq_right`, `cond_true` → `Bool.cond_true`;
  * `Set.mem_setOf_eq` → `Set.mem_ofPred_eq`, `isGδ_induced` → `IsGδ.preimage`;
  * the tactic `push_neg` → `push Not`;
  * `haveI` → `have` for propositions.
