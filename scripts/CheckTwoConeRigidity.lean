module

public import RequestProject.TuringTwoConeRepresentation
public import RequestProject.TuringConeMain

open OAI.TuringRigidity
open OAI.TuringRigidity.TwoConeRigidity

example {a b : Degree} (e : Set.Ici a ≃o Set.Ici b)
    (h : InverseBorelLift e) : b ≤ a :=
  target_le_source_of_inverse_borel_lift e h

example {a b : Degree} (e : Set.Ici a ≃o Set.Ici b)
    (h : InverseGenericProgramLift e) (k : InverseGenericProgramLift e.symm) :
    a = b := bases_eq_of_inverse_generic_programs e h k

example {a b : Degree} (e : Set.Ici a ≃o Set.Ici b)
    (h : InverseGenericProgramLift e) (k : InverseGenericProgramLift e.symm)
    (x : Set.Ici a) : (e x).val = x.val :=
  apply_val_eq_of_inverse_generic_programs e h k x

example
    (hrep : ∀ (a b : Degree) (e : Set.Ici a ≃o Set.Ici b),
      InverseGenericProgramLift e) (a b : Degree) :
    Nonempty (Set.Ici a ≃o Set.Ici b) ↔ a = b :=
  cones_orderIso_iff_of_generic_representation hrep a b

#print axioms OAI.TuringRigidity.ConeMain.no_nontrivial_cone_iso
#print axioms OAI.TuringRigidity.TwoConeRigidity.coneJoin_sup
#print axioms OAI.TuringRigidity.TwoConeRigidity.imageJoin_sup
#print axioms OAI.TuringRigidity.TwoConeRigidity.apply_pullback_val
#print axioms OAI.TuringRigidity.TwoConeRigidity.le_pullback_iff
#print axioms OAI.TuringRigidity.TwoConeRigidity.inverse_lift_countable_fibers
#print axioms OAI.TuringRigidity.TwoConeRigidity.imageJoin_le_of_inverse_borel_lift
#print axioms OAI.TuringRigidity.TwoConeRigidity.target_le_source_of_bounds
#print axioms OAI.TuringRigidity.TwoConeRigidity.target_le_source_of_inverse_borel_lift
#print axioms OAI.TuringRigidity.TwoConeRigidity.bases_eq_of_inverse_borel_lifts
#print axioms OAI.TuringRigidity.TwoConeRigidity.imageJoin_eq_of_inverse_borel_lifts
#print axioms OAI.TuringRigidity.TwoConeRigidity.apply_val_eq_of_inverse_borel_lifts
#print axioms OAI.TuringRigidity.TwoConeRigidity.inverse_generic_program_of_continuous
#print axioms OAI.TuringRigidity.TwoConeRigidity.inverse_borel_lift_of_generic_program
#print axioms OAI.TuringRigidity.TwoConeRigidity.inverse_borel_lift_of_generic_continuous
#print axioms OAI.TuringRigidity.TwoConeRigidity.target_le_source_of_inverse_generic_program
#print axioms OAI.TuringRigidity.TwoConeRigidity.bases_eq_of_inverse_generic_programs
#print axioms OAI.TuringRigidity.TwoConeRigidity.apply_val_eq_of_inverse_generic_programs
#print axioms OAI.TuringRigidity.TwoConeRigidity.bases_eq_of_inverse_generic_continuous_lifts
#print axioms OAI.TuringRigidity.TwoConeRigidity.cones_orderIso_iff_of_generic_representation
#print axioms OAI.TuringRigidity.TwoConeRigidity.apply_val_eq_of_generic_representation
