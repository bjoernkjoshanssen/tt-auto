module

public import RequestProject.TuringTwoConePresentationCountability

@[expose] public section

open OAI.TuringRigidity
open OracleJump ArithmeticHierarchy PersistentRestrictions
open ConePersistence (Cone)

#print axioms TwoConeEnumeration.enumeration_exists
#print axioms TwoConeEnumeration.transport_enumeration
#print axioms TwoConePresentation.graph_sigma_of_bound
#print axioms TwoConePresentation.graph_agreement
#print axioms TwoConePresentation.arithmetic_presentation_of_extension
#print axioms TwoConePresentation.arithmetic_presentation_of_persistent
#print axioms TwoConePresentation.arithmetic_presentation
#print axioms TwoConePresentation.graphOracle_injective
#print axioms TwoConePresentation.graphOracle_reduces
#print axioms TwoConePresentation.recursive_maps_countable
#print axioms TwoConePresentation.arithmetic_maps_countable
#print axioms TwoConePresentation.persistent_maps_countable
#print axioms TwoConePresentation.arithmetic_restriction

example {I : CountableIdeal} {a b : Degree}
    (rho : Cone I a ≃o Cone I b) (hp : TwoConePersistence.Persistent I rho)
    {H : Oracle} (hpres : ConePresentation.Presented I H)
    (hza : degreeJump a ∈ I.carrier) (hzb : degreeJump b ∈ I.carrier) :
    Sigma (iterate H 6) 5
        (TwoConePresentation.Graph rho hpres (I.lower (degree_le_jump a) hza)) ∧
      RecursivePred (iterate H 11)
        (TwoConePresentation.Graph rho hpres (I.lower (degree_le_jump a) hza)) :=
  TwoConePresentation.arithmetic_presentation rho hp hpres hza hzb

example {I K : CountableIdeal} {a b : Degree}
    (rho : Cone I a ≃o Cone I b) (sigma : Cone K a ≃o Cone K b)
    (hIK : I.carrier ⊆ K.carrier) (he : TwoConePersistence.Extends hIK rho sigma)
    {H : Oracle} (hpres : ConePresentation.Presented I H) (ha : a ∈ I.carrier)
    (hza : degreeJump a ∈ I.carrier) (hzb : degreeJump b ∈ I.carrier)
    (hH : degree (jump H) ∈ K.carrier) :
    RecursivePred (iterate H 11) (TwoConePresentation.Graph rho hpres ha) :=
  (TwoConePresentation.arithmetic_presentation_of_extension rho sigma hIK he hpres ha hza hzb hH).2

example (I : CountableIdeal) (a b : Degree)
    (hza : degreeJump a ∈ I.carrier) (hzb : degreeJump b ∈ I.carrier) :
    {rho : Cone I a ≃o Cone I b | TwoConePersistence.Persistent I rho}.Countable :=
  TwoConePresentation.persistent_maps_countable I a b hza hzb
