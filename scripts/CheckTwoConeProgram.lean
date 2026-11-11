module

public import RequestProject.TuringTwoConePullbackDefinition
public import RequestProject.TuringTwoConeSourceIdentity

@[expose] public section

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

example {a b : Degree} (e : Set.Ici a ≃o Set.Ici b)
    (h : TwoConeProgramGlobalization.CountableTests e) :
    TwoConeRigidity.InverseGenericProgramLift e :=
  TwoConeProgramGlobalization.generic_lift_of_countable_tests e h
