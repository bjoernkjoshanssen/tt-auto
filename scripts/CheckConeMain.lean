module

public import RequestProject.TuringConeMain

-- Palomar port: module visibility updated; mathematical declarations retained.
set_option backward.privateInPublic true
set_option backward.proofsInPublic true

@[expose] public section

#print axioms OAI.TuringRigidity.ConeSourceIdentity.imageJoin_degree
#print axioms OAI.TuringRigidity.ConeSourceIdentity.source_intersection
#print axioms OAI.TuringRigidity.ConeSourceIdentity.source_equation_iff
#print axioms OAI.TuringRigidity.ConePullbackDefinition.eval_joinFormula
#print axioms OAI.TuringRigidity.ConePullbackDefinition.joinCode_iff
#print axioms OAI.TuringRigidity.ConePullbackDefinition.eval_relationFormula
#print axioms OAI.TuringRigidity.ConePullbackDefinition.relation_iff_graph
#print axioms OAI.TuringRigidity.ConePullbackDefinition.graph_mem
#print axioms OAI.TuringRigidity.ConePullbackDefinition.degreeOrder_mem
#print axioms OAI.TuringRigidity.ConePullbackDefinition.graph_mem_relativeModel
#print axioms OAI.TuringRigidity.ConePullbackDefinition.graph_one_real_definition
#print axioms OAI.TuringRigidity.ConeGenericTransfer.exists_relative_prefix_triple
#print axioms OAI.TuringRigidity.ConeGenericTransfer.real_hull_prescribed_transfer
#print axioms OAI.TuringRigidity.ConePrescribedProgram.prescribed_program
#print axioms OAI.TuringRigidity.ConeMain.covering_model_with_omega_one
#print axioms OAI.TuringRigidity.ConeMain.countable_tests
#print axioms OAI.TuringRigidity.ConeMain.generic_inverse_program
#print axioms OAI.TuringRigidity.ConeMain.cone_base_eq_bot
#print axioms OAI.TuringRigidity.ConeMain.no_nontrivial_cone_iso

-- Check the public theorem types without any representation hypotheses.
open OAI.TuringRigidity
example {a : Degree} (e : Degree ≃o Set.Ici a) : a = ⊥ := ConeMain.cone_base_eq_bot e
example (a : Degree) (ha : a ≠ ⊥) : ¬ Nonempty (Degree ≃o Set.Ici a) :=
  ConeMain.no_nontrivial_cone_iso a ha
