module

public import RequestProject.TuringTwoConeMain

@[expose] public section

set_option autoImplicit false

open OAI.TuringRigidity

#print axioms TwoConePullbackProgram.inverseAt_prescribed
#print axioms TwoConePullbackProgram.mem_pullbackGraph
#print axioms TwoConePullbackProgram.output_of_degree
#print axioms TwoConePullbackProgram.output_action
#print axioms TwoConePullbackProgram.model_outputs_of_restriction
#print axioms TwoConePullbackProgram.own_program_prescribed
#print axioms TwoConePullbackDefinition.relation_iff_graph
#print axioms TwoConePullbackDefinition.graph_mem
#print axioms TwoConePullbackDefinition.graph_mem_relativeModel
#print axioms TwoConePullbackDefinition.graph_one_real_definition
#print axioms TwoConeProgramGlobalization.program_of_countable_tests
#print axioms TwoConeProgramGlobalization.generic_lift_of_arithmetic_program
#print axioms TwoConeProgramGlobalization.generic_lift_of_countable_tests
#print axioms TwoConeSourceIdentity.imageJoin_degree
#print axioms TwoConeSourceIdentity.source_intersection
#print axioms TwoConeSourceIdentity.source_equation_iff
#print axioms TwoConeGenericTransfer.real_hull_prescribed_transfer
#print axioms TwoConePrescribedProgram.prescribed_program
#print axioms TwoConeMain.covering_model_with_omega_one
#print axioms TwoConeMain.countable_tests
#print axioms TwoConeMain.arithmetic_inverse_program
#print axioms TwoConeMain.generic_inverse_program
#print axioms TwoConeMain.inverse_borel_lift
#print axioms TwoConeMain.cones_orderIso_iff
#print axioms TwoConeMain.cone_iso_apply_val
#print axioms TwoConeMain.cone_automorphism_eq_refl
#print axioms TwoConeMain.cone_iso_unique

/-- Exact unconditional types: no unbound section parameters or implicit
regularity, persistence, determinacy, or model-existence assumptions. -/
example (a b : Degree) : Nonempty (Set.Ici a ≃o Set.Ici b) ↔ a = b :=
  TwoConeMain.cones_orderIso_iff a b

example {a b : Degree} (e : Set.Ici a ≃o Set.Ici b) :
    TwoConeRigidity.InverseGenericProgramLift e :=
  TwoConeMain.generic_inverse_program e

example {a b : Degree} (e : Set.Ici a ≃o Set.Ici b) :
    ∃ (R : Oracle) (p : OracleCode), degree R = TwoConeLocality.forwardAnchor e ∧
      ∀ X, ArithmeticPrefixForcing.Generic (fun _ => OracleJump.iterate R 5) X →
        GenericIdentity.Total p (OracleJump.iterate R 5) X ∧
          degree (GenericIdentity.value p (OracleJump.iterate R 5) X) =
            TwoConeRigidity.pullback e (degree X) :=
  TwoConeMain.arithmetic_inverse_program e

example {a b : Degree} (e : Set.Ici a ≃o Set.Ici b) (x : Set.Ici a) :
    (e x).val = x.val := TwoConeMain.cone_iso_apply_val e x

example {a : Degree} (e : Set.Ici a ≃o Set.Ici a) :
    e = OrderIso.refl (Set.Ici a) := TwoConeMain.cone_automorphism_eq_refl e

example {a b : Degree} (e f : Set.Ici a ≃o Set.Ici b) : e = f :=
  TwoConeMain.cone_iso_unique e f
