module

public import RequestProject.TuringTwoConeInternalPersistence

@[expose] public section

open OAI.TuringRigidity
open EncodedForcing OracleJump ArithmeticHierarchy PersistentRestrictions
open BoundedSetTheory TransitiveNameModel SetModelReals
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
#print axioms TwoConeRealClosure.graph_mem
#print axioms TwoConeRealClosure.extension_witnesses
#print axioms TwoConePersistenceAbsoluteness.internalPresentation_iff
#print axioms TwoConePersistenceAbsoluteness.internal_criterion_iff_persistent
#print axioms TwoConePersistenceAbsoluteness.persistent_presentation_mem
#print axioms TwoConePersistenceAbsoluteness.internalExistence_iff
#print axioms TwoConePersistenceAbsoluteness.presentation_comparison
#print axioms TwoConePersistenceAbsoluteness.existence_comparison
#print axioms TwoConeInternalPersistence.matrix_of_extensions
#print axioms TwoConeInternalPersistence.internal_extensions_iff_persistent
#print axioms TwoConeInternalPersistence.internal_extensions_comparison

example {I : CountableIdeal} {B C H : Oracle}
    (hpres : ConePresentation.Presented I H) {P : ℕ → Prop}
    (h : TwoConeNumerical.Action B C H P) :
    ∃ rho : Cone I (degree B) ≃o Cone I (degree C),
      ∀ v, P v ↔ TwoConePresentation.RawGraph rho H v :=
  TwoConeNumerical.reconstruct hpres h

example {I : CountableIdeal} {a b : Degree} {H Y : Oracle}
    (rho : Cone I a ≃o Cone I b)
    (h : RecursivePred Y (TwoConePresentation.RawGraph rho H)) :
    ∃ e : ℕ, ∀ v, UniformArithmetic.tableOracle Y e v = true ↔
      TwoConePresentation.RawGraph rho H v :=
  TwoConeArithmeticCriterion.graph_program rho h

example (k : ℕ) : ArithmeticPersistence.PiOneOne
    (fun A R => TwoConePersistenceComplexity.Property A R k) :=
  TwoConePersistenceComplexity.piOneOne k

example (M : ZFSet) (hM : Transitive M) (hT : SourceT M)
    {I : CountableIdeal} {A R : Oracle} (hA : ConePresentation.Presented I A)
    (hAM : A ∈ reals M) (hRM : R ∈ reals M) (k : ℕ)
    (rho : Cone I (degree (columns A (Nat.unpair k).1)) ≃o
      Cone I (degree (columns A (Nat.unpair k).2)))
    (hza : degreeJump (degree (columns A (Nat.unpair k).1)) ∈ I.carrier)
    (hzb : degreeJump (degree (columns A (Nat.unpair k).2)) ∈ I.carrier)
    (hR : ∀ v, R v = true ↔ TwoConePresentation.RawGraph rho A v) :
    TwoConeInternalPersistence.HasExtensions (reals M) A R k ↔
      TwoConePersistence.Persistent I rho :=
  TwoConeInternalPersistence.internal_extensions_iff_persistent M hM hT
    hA hAM hRM k rho hza hzb hR
