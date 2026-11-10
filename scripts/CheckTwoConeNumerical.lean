module

public import RequestProject.TuringTwoConePersistenceComplexity

@[expose] public section

open OAI.TuringRigidity
open EncodedForcing OracleJump ArithmeticHierarchy PersistentRestrictions
open ConePersistence (Cone)

#print axioms TwoConeNumerical.action_congr
#print axioms TwoConeNumerical.action_of_iso
#print axioms TwoConeNumerical.reconstruct
#print axioms TwoConeNumerical.compatible_iff
#print axioms TwoConeNumerical.graphOracle_true
#print axioms TwoConeNumerical.graphOracle_reduces
#print axioms TwoConeArithmeticCriterion.action_arith
#print axioms TwoConeArithmeticCriterion.graph_program
#print axioms TwoConeArithmeticCriterion.persistent_iff
#print axioms TwoConeArithmeticCriterion.matrix_arith
#print axioms TwoConePersistenceComplexity.property_iff
#print axioms TwoConePersistenceComplexity.base_arith
#print axioms TwoConePersistenceComplexity.presentationMatrix_arith
#print axioms TwoConePersistenceComplexity.presentationMatrix_iff
#print axioms TwoConePersistenceComplexity.piOneOne_uniform
#print axioms TwoConePersistenceComplexity.piOneOne

example {I : CountableIdeal} {B C H : Oracle}
    (hpres : ConePresentation.Presented I H) {P : ℕ → Prop}
    (h : TwoConeNumerical.Action B C H P) :
    ∃ rho : Cone I (degree B) ≃o Cone I (degree C),
      ∀ v, P v ↔ TwoConePresentation.RawGraph rho H v :=
  TwoConeNumerical.reconstruct hpres h

example {I : CountableIdeal} {a b : Degree} {H Y : Oracle}
    (rho : Cone I a ≃o Cone I b)
    (h : RecursivePred Y (TwoConePresentation.RawGraph rho H)) :
    ∃ e : ℕ, ∀ v, NumericalExtension.tableOracle Y e v = true ↔
      TwoConePresentation.RawGraph rho H v :=
  TwoConeArithmeticCriterion.graph_program rho h

example (k : ℕ) : ArithmeticPersistence.PiOneOne
    (fun A R => TwoConePersistenceComplexity.Property A R k) :=
  TwoConePersistenceComplexity.piOneOne k
