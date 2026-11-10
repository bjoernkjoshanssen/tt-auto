module

public import RequestProject.TuringTwoConePersistentLocality

open OAI.TuringRigidity
open IdealInterpretation OracleJump TwoConeIdealCodes
open PersistentRestrictions ConePersistence

-- Exact types: no hidden regularity, persistence, or jump-preservation assumption.
example {I J : DegreeIdeal} {a : I} {b : J}
    (e : Set.Ici a ≃o Set.Ici b) (z : Set.Ici b)
    (hz : val z = degreeJump b.val) (x : Set.Ici a) :
    val (e x) ≤ GlobalLocality.degreeIterate (val x ⊔ val (e.symm z)) 5 :=
  TwoConeIdealLocality.image_le_fifth_jump e z hz x

example {a b : Degree} (I J : CountableIdeal)
    (e : Cone I a ≃o Cone I b) (hp : TwoConePersistence.Persistent I e)
    (ha : degreeJump a ∈ I.carrier) (hb : degreeJump b ∈ I.carrier)
    (hIJ : I.carrier ⊆ J.carrier)
    (hJ : IdealLocality.JumpClosed (PersistentLocality.ideal J)) :
    ∃ f : Cone J a ≃o Cone J b, TwoConePersistence.Extends hIJ e f :=
  TwoConePersistentLocality.persistent_jump_extension I J e hp ha hb hIJ hJ

#print axioms TwoConeIdealCodes.ambient_injective
#print axioms TwoConeIdealCodes.val_finset_sup
#print axioms TwoConeIdealCodes.map_finset_sup
#print axioms TwoConeIdealCodes.ACode.transport
#print axioms TwoConeIdealCodes.ACode.map_below
#print axioms TwoConeIdealCodes.SCode.transport
#print axioms TwoConeIdealCodes.SCode.map_below
#print axioms TwoConeIdealCodes.RCode.internal
#print axioms TwoConeIdealCodes.RCode.transport
#print axioms TwoConeIdealCodes.RCode.transport_one
#print axioms TwoConeIdealCodes.RCode.transport_two
#print axioms TwoConeIdealCodes.RCode.coordinates_mem
#print axioms TwoConeIdealCodes.RCode.map_below
#print axioms TwoConeIdealCodes.liftRelation_external
#print axioms TwoConeIdealCodes.transport_copy
#print axioms TwoConeIdealLocality.image_arithmetic
#print axioms TwoConeIdealLocality.inverse_arithmetic
#print axioms TwoConeIdealLocality.image_le_fifth_jump
#print axioms TwoConeIdealLocality.inverse_le_fifth_jump
#print axioms TwoConeIdealLocality.image_mem
#print axioms TwoConeIdealLocality.inverse_mem
#print axioms TwoConeIdealLocality.invariant
#print axioms TwoConeIdealLocality.restrict_jump_ideal
#print axioms TwoConePersistentLocality.restrict_extension
#print axioms TwoConePersistentLocality.persistent_jump_extension
#print axioms TwoConePersistentLocality.persistent_jump_extension_of_jump_closed
#print axioms TwoConePersistentLocality.arithmetic_ideal_extension
