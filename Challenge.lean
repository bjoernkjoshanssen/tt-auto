module

public import Mathlib.Computability.TuringDegree
public import Mathlib.Order.Hom.Basic

/-!
# No proper upper cone is isomorphic to the Turing degrees

The statement below concerns the ordinary Turing degrees of subsets of the
natural numbers, with their usual order. A subset is represented by a Boolean
characteristic function. Reducibility is Mathlib's `TuringReducible`, and the
degrees are its antisymmetrization (quotient by mutual reducibility).

The least degree is the degree of the constantly-false characteristic function.
For a nonzero degree `a`, `Set.Ici a` is the principal upper cone, with the
inherited order. The assertion excludes an arbitrary order isomorphism onto
that cone; it has no continuity, definability, or measurability hypothesis.

This module deliberately imports only Mathlib. The elementary definitions are
repeated here so that the statement can be audited independently of the proof.
Comparator checks this statement against the declaration with the same fully
qualified name exported by `Solution`. Only the final proof is omitted here.
The source proof uses classical Lean, not a separate formal derivation in ZFC.
-/

@[expose] public section

namespace OAI.TuringRigidity

/-- A subset of the natural numbers, represented by its characteristic function. -/
abbrev Oracle := ℕ → Bool

/-- The total characteristic function, viewed as a partial natural-number function. -/
def oracleFunction (A : Oracle) : ℕ →. ℕ := fun n => Part.some (if A n then 1 else 0)

/-- Ordinary Turing reducibility of two characteristic functions. -/
def Reduces (A B : Oracle) : Prop := TuringReducible (oracleFunction A) (oracleFunction B)

instance : IsPreorder Oracle Reduces where
  refl A := TuringReducible.refl (oracleFunction A)
  trans _ _ _ h k := TuringReducible.trans h k

/-- The Turing degrees: subsets of naturals modulo mutual Turing reducibility. -/
def Degree := Antisymmetrization Oracle Reduces

instance : PartialOrder Degree :=
  @instPartialOrderAntisymmetrization Oracle
    { le := Reduces
      lt A B := Reduces A B ∧ ¬ Reduces B A
      lt_iff_le_not_ge _ _ := Iff.rfl
      le_refl A := TuringReducible.refl (oracleFunction A)
      le_trans _ _ _ h k := TuringReducible.trans h k }

/-- The equivalence class of a characteristic function. -/
def degree (A : Oracle) : Degree := toAntisymmetrization Reduces A

theorem degree_surjective : Function.Surjective degree := by
  intro a
  exact ⟨ofAntisymmetrization Reduces a, toAntisymmetrization_ofAntisymmetrization _ a⟩

/-- The least degree is the computable degree, represented by the empty set. -/
instance : OrderBot Degree where
  bot := degree (fun _ => false)
  bot_le a := by
    obtain ⟨A, rfl⟩ := degree_surjective a
    apply RecursiveIn.iff_nat.mpr
    change Nat.RecursiveIn {oracleFunction A} (fun _ => Part.some 0)
    exact .zero

namespace ConeMain

/-- No principal upper cone above a nonzero Turing degree is order-isomorphic
to the entire partially ordered set of Turing degrees. -/
theorem no_nontrivial_cone_iso (a : Degree) (ha : a ≠ ⊥) :
    ¬ Nonempty (Degree ≃o Set.Ici a) := by
  sorry

end ConeMain
end OAI.TuringRigidity
