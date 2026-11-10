module

public import RequestProject.TuringTwoConePrescribedModels

@[expose] public section

open OAI.TuringRigidity
open BoundedSetTheory TransitiveNameModel SetModelReals SetModelSyntax
open SetDegreeDecoding PersistentRestrictions OracleJump RelativeConstructible
open ElementaryModel RecursiveNames CountableForcing AtomicForcing
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
#print axioms TwoConeForcingExtension.persistent_extension_name
#print axioms TwoConeForcingExtension.ground_cone_extension_name
#print axioms TwoConeForcingExtension.global_restriction_extension_name
#print axioms TwoConeForcingExtension.model_cone_output_name
#print axioms TwoConeForcingExtension.model_cone_inverse_output_name
#print axioms TwoConeForcingDefinition.persistent_graph_one_real_definition
#print axioms TwoConeForcingDefinition.persistent_extension_one_real_definition
#print axioms TwoConeForcingDefinition.forcing_extension_one_real_definition
#print axioms TwoConeForcingDefinition.coded_forcing_extension_name
#print axioms TwoConePrescribedModels.model_restriction_of_anchors
#print axioms TwoConePrescribedModels.prescribed_covering_model

universe u

example {I : CountableIdeal} {a b : Degree} (rho : Cone I a ≃o Cone I b)
    (z : ZFSet.{u}) : z ∈ TwoConeSetGraphs.coneGraph rho ↔
      ∃ x : Cone I a, z = ZFSet.pair (degreeSet x.val) (degreeSet (rho x).val) :=
  TwoConeSetGraphs.mem_coneGraph rho z

example {M : ZFSet.{u}} (C : SetModelFunctions.Context M) {I : CountableIdeal} {a b : Degree}
    {A : Oracle} (hA : ConePresentation.Presented I A) (hAM : A ∈ SetModelReals.reals M)
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

example (M : ZFSet.{u}) [Countable (Conditions M)]
    (hM : Transitive M) (hT : SourceT M)
    {c o : ZFSet.{u}} [Preorder (Conditions c)] [Top (Conditions c)]
    (hc : c ∈ M) (hoM : o ∈ M)
    (ho : ∀ r s : Conditions c, ZFSet.pair (label c r) (label c s) ∈ o ↔ r ≤ s)
    (G : GenericFilter (Conditions c)) (hG : GroundGeneric M G) (htop : ⊤ ∈ G.carrier)
    (I : CountableIdeal) {a b : Degree} (rho : Cone I a ≃o Cone I b)
    (hp : TwoConePersistence.Persistent I rho)
    (hza : degreeJump a ∈ I.carrier) (hzb : degreeJump b ∈ I.carrier)
    (hIM : I.carrier ⊆ (modelIdeal M hM hT).carrier) :
    let E := genericExtensionSet M c G.carrier
    let hE := genericExtensionSet_transitive M c hM G.carrier
    let hTE := extension_sourceT M hM hT hc hoM ho G hG htop
    let J := modelIdeal E hE hTE
    ∃ hIJ : I.carrier ⊆ J.carrier, ∃ sigma : Cone J a ≃o Cone J b,
      TwoConePersistence.Extends hIJ rho sigma ∧ TwoConePersistence.Persistent J sigma ∧
      TwoConeSetGraphs.coneGraph sigma ∈ relativeModel E (groundReals E) ∧
      ∃ t : Name (Conditions c), t.encode (label c) ∈ M ∧
        t.val G.carrier = TwoConeSetGraphs.coneGraph sigma :=
  TwoConeForcingExtension.persistent_extension_name M hM hT hc hoM ho G hG htop
    I rho hp hza hzb hIM

example {a b : Degree} (e : Set.Ici a ≃o Set.Ici b) (W : ℕ → Oracle) :
    ∃ M : ZFSet.{u}, ∃ hM : Transitive M, ∃ hT : SourceT M,
      ∃ hcount : Countable (Conditions M),
        letI := hcount
        (∀ n, W n ∈ modelReals M) ∧
          ∃ rho : Cone (modelIdeal M hM hT) a ≃o Cone (modelIdeal M hM hT) b,
            TwoConePersistence.RestrictsTo e (modelIdeal M hM hT) rho ∧
            TwoConePersistence.Persistent (modelIdeal M hM hT) rho ∧
            TwoConeSetGraphs.coneGraph rho ∈ relativeModel M (groundReals M) :=
  TwoConePrescribedModels.prescribed_covering_model e W
