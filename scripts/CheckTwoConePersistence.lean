module

public import RequestProject.TuringTwoConePersistentExtension

@[expose] public section

open OAI.TuringRigidity
open OracleJump ArithmeticHierarchy PersistentRestrictions
open ConePersistence (Cone)
open TwoConePersistentExtension

#print axioms TwoConePersistentExtension.persistent_symm
#print axioms TwoConePersistentExtension.persistent_symm_iff
#print axioms TwoConePersistentExtension.nonpersistent_witness
#print axioms TwoConePersistentExtension.persistent_extension
#print axioms TwoConePersistentExtension.persistent_extension_of_jump_closed
#print axioms TwoConePersistentExtension.persistent_arithmetic_extension
#print axioms TwoConePersistentExtension.persistent_countable_jump_extension
#print axioms TwoConePersistentExtension.persistent_iff_arithmetic_extensions

-- No global map, regularity, or arithmetic-extension hypothesis is supplied.
example {a b : Degree} (I J : CountableIdeal)
    (rho : Cone I a ≃o Cone I b) (hp : TwoConePersistence.Persistent I rho)
    (hza : degreeJump a ∈ I.carrier) (hzb : degreeJump b ∈ I.carrier)
    (hIJ : I.carrier ⊆ J.carrier)
    (hJ : IdealLocality.JumpClosed (PersistentLocality.ideal J)) :
    ∃ sigma : Cone J a ≃o Cone J b,
      TwoConePersistence.Extends hIJ rho sigma ∧ TwoConePersistence.Persistent J sigma :=
  persistent_extension I J rho hp hza hzb hIJ hJ

-- Jump-closed starting ideals require only explicit base membership.
example {a b : Degree} (I J : CountableIdeal)
    (rho : Cone I a ≃o Cone I b) (hp : TwoConePersistence.Persistent I rho)
    (ha : a ∈ I.carrier) (hb : b ∈ I.carrier)
    (hI : IdealLocality.JumpClosed (PersistentLocality.ideal I))
    (hIJ : I.carrier ⊆ J.carrier)
    (hJ : IdealLocality.JumpClosed (PersistentLocality.ideal J)) :
    ∃ sigma : Cone J a ≃o Cone J b,
      TwoConePersistence.Extends hIJ rho sigma ∧ TwoConePersistence.Persistent J sigma :=
  persistent_extension_of_jump_closed I J rho hp ha hb hI hIJ hJ

-- One persistent extension has arithmetic graphs in both directions.
example {a b : Degree} (I J : CountableIdeal)
    (rho : Cone I a ≃o Cone I b) (hp : TwoConePersistence.Persistent I rho)
    (hza : degreeJump a ∈ I.carrier) (hzb : degreeJump b ∈ I.carrier)
    (hIJ : I.carrier ⊆ J.carrier)
    (hJ : IdealLocality.JumpClosed (PersistentLocality.ideal J))
    {H : Oracle} (hpres : ConePresentation.Presented J H) :
    ∃ sigma : Cone J a ≃o Cone J b,
      TwoConePersistence.Extends hIJ rho sigma ∧ TwoConePersistence.Persistent J sigma ∧
      RecursivePred (iterate H 11) (TwoConePresentation.RawGraph sigma H) ∧
      RecursivePred (iterate H 11) (TwoConePresentation.RawGraph sigma.symm H) :=
  persistent_arithmetic_extension I J rho hp hza hzb hIJ hJ hpres

example {a b : Degree} (I : CountableIdeal) (rho : Cone I a ≃o Cone I b)
    (hza : degreeJump a ∈ I.carrier) (hzb : degreeJump b ∈ I.carrier) :
    TwoConePersistence.Persistent I rho ↔
      (∀ (J : CountableIdeal) (hIJ : I.carrier ⊆ J.carrier),
        IdealLocality.JumpClosed (PersistentLocality.ideal J) →
        ∀ (H : Oracle), ConePresentation.Presented J H →
          ∃ sigma : Cone J a ≃o Cone J b,
            TwoConePersistence.Extends hIJ rho sigma ∧
            RecursivePred (iterate H 11) (TwoConePresentation.RawGraph sigma H)) :=
  persistent_iff_arithmetic_extensions I rho hza hzb
