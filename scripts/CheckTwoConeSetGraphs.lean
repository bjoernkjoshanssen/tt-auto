module

public import RequestProject.TuringTwoConeConstructibleExtension

@[expose] public section

open OAI.TuringRigidity
open BoundedSetTheory TransitiveNameModel SetModelReals SetModelSyntax
open SetDegreeDecoding PersistentRestrictions OracleJump RelativeConstructible
open ConePersistence (Cone)

#print axioms TwoConeSetGraphs.mem_coneGraph
#print axioms TwoConeSetGraphs.coneGraph_subset
#print axioms TwoConeSetGraphs.extends_graphs
#print axioms TwoConeSetGraphs.action_eq_coneGraph
#print axioms TwoConeSetGraphs.graphImage_action
#print axioms TwoConeSetGraphs.coded_sets
#print axioms TwoConeModelGraphs.persistent_sets
#print axioms TwoConeModelGraphs.persistent_mem_of_counted_reals
#print axioms TwoConeModelGraphs.persistent_extension_sets
#print axioms TwoConeForcingDescent.real_collapse_reconstructs
#print axioms TwoConeForcingDescent.persistent_graph_mem_of_real_family
#print axioms TwoConeConstructibleExtension.persistent_modelIdeal_graph_mem_relativeModel
#print axioms TwoConeConstructibleExtension.persistent_modelIdeal_graph_in_relativeL
#print axioms TwoConeConstructibleExtension.persistent_extension_in_relativeModel
#print axioms TwoConeConstructibleExtension.persistent_extension_in_model
#print axioms TwoConeConstructibleExtension.persistent_graph_construction
#print axioms TwoConeConstructibleExtension.persistent_extension_construction

universe u

example {I : CountableIdeal} {a b : Degree} (rho : Cone I a ≃o Cone I b)
    (z : ZFSet.{u}) : z ∈ TwoConeSetGraphs.coneGraph rho ↔
      ∃ x : Cone I a, z = ZFSet.pair (degreeSet x.val) (degreeSet (rho x).val) :=
  TwoConeSetGraphs.mem_coneGraph rho z

example {M : ZFSet.{u}} (C : Context M) {I : CountableIdeal} {a b : Degree}
    {A : Oracle} (hA : ConePresentation.Presented I A) (hAM : A ∈ reals M)
    (rho : Cone I a ≃o Cone I b) (hp : TwoConePersistence.Persistent I rho)
    (hza : degreeJump a ∈ I.carrier) (hzb : degreeJump b ∈ I.carrier) :
    idealSet I ∈ M ∧ TwoConeSetGraphs.coneGraph rho ∈ M :=
  TwoConeModelGraphs.persistent_sets C hA hAM rho hp hza hzb

example (M : ZFSet.{u}) [Countable (Conditions M)] (hM : Transitive M) (hT : SourceT M)
    (I : CountableIdeal) {a b : Degree} (rho : Cone I a ≃o Cone I b)
    (hp : TwoConePersistence.Persistent I rho)
    (hza : degreeJump a ∈ I.carrier) (hzb : degreeJump b ∈ I.carrier)
    (hIM : I.carrier ⊆ (modelIdeal M hM hT).carrier) :
    ∃ sigma : Cone (modelIdeal M hM hT) a ≃o Cone (modelIdeal M hM hT) b,
      TwoConePersistence.Extends hIM rho sigma ∧
      TwoConePersistence.Persistent (modelIdeal M hM hT) sigma ∧
      TwoConeSetGraphs.coneGraph sigma ∈ relativeModel M (groundReals M) :=
  TwoConeConstructibleExtension.persistent_extension_in_relativeModel M hM hT I rho hp hza hzb hIM
