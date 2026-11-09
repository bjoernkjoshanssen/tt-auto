module

public import RequestProject.TuringConeRealParameterProgram
public import RequestProject.TuringConePullbackDefinition
public import RequestProject.TuringConeGenericTransfer
public import OAI.Computability.DegreeRigidity.SetModels.NoNewOrdinals



-- Module-system port for Palomar; mathematical bodies retained.
set_option backward.privateInPublic true
set_option backward.privateInPublic.warn false
set_option backward.proofsInPublic true

@[expose] public section

/-!
# A prescribed inverse program for one Cohen extension

The cone map on the extension's degrees is chosen by restricting the original
global map, using the two locality anchors. Its inverse-join graph is therefore
coherent with the original map, not merely an arbitrary extension of an old
partial map. Constructibility gives the one-real definition, parameter transport
and symmetry give one program, and the relative source equation transfers its
correctness to all arithmetic-generic inputs of this extension.
-/

namespace OAI.TuringRigidity.ConePrescribedProgram

open TransitiveNameModel BoundedSetTheory ElementaryModel SetDegreeDecoding
open PersistentRestrictions ConePersistence ConePullbackProgram ConeProgramGlobalization
open RelativeConstructible RecursiveNames CountableForcing AtomicForcing CohenGroundPoset
open CohenColumnRealName InternalCountableOrdinals OracleJump GenericIdentity

attribute [local instance] InternalCollapse.order InternalCollapse.collapsePreorder
  CohenNiceNameConstruction.cohenTop

/-- One program works for every arithmetic-generic real of the chosen
extension. Its fixed oracle parameter represents the original e(0'). -/
theorem prescribed_program {a : Degree} (e : Degree ≃o Set.Ici a)
    (M K : ZFSet.{0}) [Countable (Conditions M)]
    (hM : Transitive M) (hT : SourceT M) (hK : FirstUncountable M K)
    (hpost : (e (degree (jump FixedArithmetic.zero))).val ∈ (modelIdeal M hM hT).carrier)
    (hpre : e.symm ⟨degreeJump a, Set.mem_Ici.mpr (degree_le_jump a)⟩ ∈
      (modelIdeal M hM hT).carrier)
    (G : GenericFilter (Conditions (poset K))) (hG : GroundGeneric M G) :
    ∃ (R : Oracle) (p : OracleCode),
      degree R = (e (degree (jump FixedArithmetic.zero))).val ∧
      ∀ Y : Oracle, realCode Y ∈ genericExtensionSet M (poset K) G.carrier →
        ArithmeticPrefixForcing.Generic (fun _ => iterate R 5) Y →
          RepresentsInverseAt e p (iterate R 5) Y := by
  let c := poset K
  let E := genericExtensionSet M c G.carrier
  have hc := (manyColumn_internal M K hM hT hK.2.1).1
  have ho := (manyColumn_internal M K hM hT hK.2.1).2
  have ht : (⊤ : Conditions c) ∈ G.carrier := G.upper le_top G.nonempty.choose_spec
  have hE := genericExtensionSet_transitive M c hM G.carrier
  have hTE := extension_sourceT M hM hT hc ho (InternalCollapse.orderSet_pair c) G hG ht
  have hME := ground_inclusion_set M c hM hT.pairing hT.union hT.powerSet
    hT.separation.finitePrefix.bounded hT.replacement.finitePrefix hT.infinity hc G.carrier ht
  let I := modelIdeal M hM hT
  let J := modelIdeal E hE hTE
  have hIJ : I.carrier ⊆ J.carrier := by
    rintro d ⟨D, hD, rfl⟩
    refine ⟨D, ?_, rfl⟩
    change realCode D ∈ E
    exact hME hD
  obtain ⟨ρ, hρ, _, _⟩ := ConePrescribedModels.model_restriction_of_anchors e M hM hT hpost hpre
  obtain ⟨σ, hσ, hpσ, _⟩ := ConePrescribedModels.model_restriction_of_anchors
    e E hE hTE (hIJ hpost) (hIJ hpre)
  have he : ConePersistence.Extends hIJ ρ σ := by
    intro x
    exact (hσ ⟨x.val, hIJ x.property⟩).symm.trans (hρ x)
  have hz : degree (jump FixedArithmetic.zero) ∈ I.carrier :=
    ⟨jump FixedArithmetic.zero, sourceT_real_jump M hM hT (sourceT_zero_real M hM hT), rfl⟩
  obtain ⟨R, hRM, hR⟩ := hpost
  change realCode R ∈ M at hRM
  have hRρ : degree R = (ρ ⟨degree (jump FixedArithmetic.zero), hz⟩).val :=
    hR.trans (hρ ⟨degree (jump FixedArithmetic.zero), hz⟩)
  have houtputs := ConeRealParameterProgram.model_extension_outputs E hE hTE I ρ hIJ σ he hz R hRρ
  have hgraphE : pullbackGraph σ ∈ E := relativeModel_subset E _
    (ConePullbackDefinition.graph_mem_relativeModel E hE hTE σ hpσ)
  obtain ⟨δ, P, φ, hδ, hPE, _, hPL, hdef⟩ :=
    ConePullbackDefinition.graph_one_real_definition E hE hTE σ hpσ
  have hδM := extension_ordinal_ground M c hM hT G.carrier δ hδ
  obtain ⟨f, hf, hfg⟩ := (mem_extensionSet M c G.carrier _).mp hgraphE
  obtain ⟨τ, hτ, hτv⟩ := (mem_extensionSet M c G.carrier (realCode P)).mp hPE
  have hreal : τ.val G.carrier ⊆ ZFSet.omega := by rw [hτv]; exact realCode_subset P
  have hXL : τ.val G.carrier ∈ level (groundReals E) δ := hτv.symm ▸ hPL
  have hdef' : f.val G.carrier = definedSubset (level (groundReals E) δ) φ
      (fun _ : Fin φ.bound => τ.val G.carrier) := by
    rw [hfg, hτv]
    exact hdef
  have houtputs' : ∀ A ∈ modelReals E, ∃ X : Oracle,
      Reduces X (iterate (join A R) 5) ∧ Output E (f.val G.carrier) A X := by
    rw [hfg]
    exact houtputs
  obtain ⟨i, hi⟩ := InternalCountableOrdinals.nonempty M K hK
  obtain ⟨hN, _, fX, _, _, GX, _, _, _, p, _, hsem, _⟩ :=
    ConeRealParameterProgram.program_from_one_real_definition M K i hM hT hK hi R hRM
      τ f hτ hf G hG hreal δ hδM φ hXL hdef' houtputs'
  rw [hτv] at hN hsem
  let N := RealGeneratedModel.hull M (realCode P)
  have hRN : R ∈ modelReals N := by
    change realCode R ∈ N
    exact hN.2.2.1 hRM
  have hRP : realCode (iterate R 5) ∈ N :=
    sourceT_real_iterate N hN.1 hN.2.1 hRN 5
  obtain ⟨A, hA⟩ := degree_surjective a
  have hAR : Reduces A R := by
    change degree A ≤ degree R
    rw [hA, hR]
    exact Set.mem_Ici.mp (e (degree (jump FixedArithmetic.zero))).property
  have hAM : realCode A ∈ M := sourceT_real_lower M hM hT hRM hAR
  have hAN : realCode A ∈ N := hN.2.2.1 hAM
  have hsem' : ∀ H : GenericFilter (Conditions (poset K)), GroundGeneric N H →
      genericExtensionSet N (poset K) H.carrier = E →
      ∀ Y : Oracle, (realName K i).val H.carrier = realCode Y →
        RepresentsInverseAt e p (iterate R 5) Y := by
    intro H hH hEq Y hv
    have hy := hsem H hH hEq Y hv
    rw [hfg] at hy
    exact own_program_prescribed e σ hσ E p (iterate R 5) Y hy
  have hrep := (ConeGenericTransfer.real_hull_prescribed_transfer e M K i hM hT hK hi
    G hG P A hPE hA hAN p (iterate R 5) hRP hsem').2
  exact ⟨R, p, hR, hrep⟩

end OAI.TuringRigidity.ConePrescribedProgram
