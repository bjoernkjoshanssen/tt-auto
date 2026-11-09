module

public import Mathlib

/-!
# No proper principal upper cone of the Turing degrees is the whole structure

This is the independently readable statement for Palomar. It imports Mathlib
only, not the proof development. An oracle is a subset of the natural numbers,
represented by its Boolean characteristic function. Reducibility is Mathlib's
ordinary Turing reducibility of these characteristic functions; degrees are the
quotient by mutual reducibility. The bottom degree is the degree of the empty
set. `Set.Ici a` carries the inherited order on the degrees greater than or equal
to `a`, and `\u2243o` means an order isomorphism, not merely an embedding.

The theorem asserts that, for every nonzero Turing degree `a`, no such order
isomorphism from all degrees onto the cone above `a` exists. There are no
regularity, determinacy, or presentation hypotheses. The deliberate `sorry`
below belongs only to this Challenge; Solution imports the checked proof.

The elementary definitions below reproduce the existing proof's definitions,
so Comparator can check the exact declaration rather than a renamed surrogate.
The proof adapts the degree-coding, persistence and generic-representation
machinery used in the upstream rigidity development. See formalization.yaml
and PALOMAR.md for provenance, AI usage, and review limitations.
-/

@[expose] public section

namespace OAI.TuringRigidity

/-- A subset of the natural numbers, given by its characteristic function. -/
abbrev Oracle := \u2115 \u2192 Bool

/-- The total characteristic function, regarded as a partial natural function. -/
def oracleFunction (A : Oracle) : \u2115 \u2192. \u2115 :=
  fun n => Part.some (if A n then 1 else 0)

/-- Ordinary Turing reducibility of subsets of the natural numbers. -/
def Reduces (A B : Oracle) : Prop :=
  TuringReducible (oracleFunction A) (oracleFunction B)

instance : IsPreorder Oracle Reduces where
  refl A := TuringReducible.refl (oracleFunction A)
  trans _ _ _ h k := TuringReducible.trans h k

/-- Turing degrees: identify two oracles precisely when each computes the other. -/
def Degree := Antisymmetrization Oracle Reduces

instance : PartialOrder Degree :=
  @instPartialOrderAntisymmetrization Oracle
    { le := Reduces
      lt A B := Reduces A B \u2227 \u00ac Reduces B A
      lt_iff_le_not_ge _ _ := Iff.rfl
      le_refl A := TuringReducible.refl (oracleFunction A)
      le_trans _ _ _ h k := TuringReducible.trans h k }

/-- The equivalence class of an oracle under mutual Turing reducibility. -/
def degree (A : Oracle) : Degree := toAntisymmetrization Reduces A

theorem degree_surjective : Function.Surjective degree := by
  intro a
  exact \u27e8ofAntisymmetrization Reduces a, toAntisymmetrization_ofAntisymmetrization _ a\u27e9

/-- The bottom degree is the computable degree, represented by the empty set. -/
instance : OrderBot Degree where
  bot := degree (fun _ => false)
  bot_le a := by
    obtain \u27e8A, rfl\u27e9 := degree_surjective a
    apply RecursiveIn.iff_nat.mpr
    change Nat.RecursiveIn {oracleFunction A} (fun _ => Part.some 0)
    exact .zero

/-- No principal upper cone with noncomputable base is order-isomorphic to
all Turing degrees. This is the sole result selected by comparator.json. -/
theorem ConeMain.no_nontrivial_cone_iso (a : Degree) (ha : a \u2260 \u22a5) :
    \u00ac Nonempty (Degree \u2243o Set.Ici a) := by
  sorry

end OAI.TuringRigidity
