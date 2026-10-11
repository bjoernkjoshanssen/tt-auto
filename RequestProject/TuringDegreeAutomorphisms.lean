import OAI.Computability.DegreeRigidity.Main

/-!
# Any two automorphisms of the Turing degrees are equal

The library `OAI.Computability.DegreeRigidity` (imported from
`https://github.com/openai/math/tree/main/lean/OAI/Computability/DegreeRigidity`) proves
`OAI.TuringRigidity.ManuscriptMain.rigidity : OAI.TuringRigidity.MainTheorem`, i.e. every order
automorphism `π : Degree ≃o Degree` of the Turing degrees fixes every degree.

Here `Degree` is the library's type of Turing degrees: the antisymmetrization of oracles
`ℕ → Bool` under Mathlib's Turing reducibility `TuringReducible`, ordered by reducibility.

The statement (*) follows in one line: both automorphisms agree with the identity pointwise.
-/

open OAI.TuringRigidity

/-- (*) If `π₁` and `π₂` are automorphisms of the Turing degrees, then `π₁ = π₂`. -/
theorem turingDegree_automorphisms_eq (π₁ π₂ : Degree ≃o Degree) : π₁ = π₂ :=
  OrderIso.ext <| funext fun a => (ManuscriptMain.rigidity π₁ a).trans (ManuscriptMain.rigidity π₂ a).symm
