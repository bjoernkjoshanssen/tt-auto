module

public import RequestProject.TuringConePrescribedProgram
public import OAI.Computability.DegreeRigidity.SetModels.ValidFirstUncountable
public import OAI.Computability.DegreeRigidity.CohenForcing.CohenGroundGeneric



-- Module-system port for Palomar; mathematical bodies retained.
set_option backward.privateInPublic true
set_option backward.privateInPublic.warn false
set_option backward.proofsInPublic true

@[expose] public section

/-!
# Cone rigidity from a uniform generic inverse program

The parameter-covering model contains a prescribed countable sequence and
representatives of the two locality anchors. The prescribed-program theorem
handles all arithmetic-generic members of that sequence. Diagonalization over
the countably many parameter/program candidates gives a global generic lift,
and the previously checked analytic cone-rigidity theorem finishes the proof.
-/

namespace OAI.TuringRigidity.ConeMain

open TransitiveNameModel BoundedSetTheory ElementaryModel RelationCollapse
open PersistentRestrictions OracleJump InternalCountableOrdinals
open CountableForcing ConeProgramGlobalization ConeRigidity

attribute [local instance] InternalCollapse.order InternalCollapse.collapsePreorder
  CohenNiceNameConstruction.cohenTop

noncomputable section

/-- The source models can be chosen to have an internal first uncountable
ordinal while containing arbitrary prescribed real inputs and both anchors. -/
theorem covering_model_with_omega_one {a : Degree} (e : Degree ≃o Set.Ici a)
    (W : ℕ → Oracle) :
    ∃ M : ZFSet.{0}, ∃ hM : Transitive M, ∃ hT : SourceT M,
      ∃ hcount : Countable (Conditions M),
        letI := hcount
        ∃ K : ZFSet.{0}, FirstUncountable M K ∧
          (∀ n, W n ∈ modelReals M) ∧
          (e (degree (jump FixedArithmetic.zero))).val ∈ (modelIdeal M hM hT).carrier ∧
          e.symm ⟨degreeJump a, Set.mem_Ici.mpr (degree_le_jump a)⟩ ∈
            (modelIdeal M hM hT).carrier := by
  obtain ⟨B, hB⟩ := degree_surjective (e (degree (jump FixedArithmetic.zero))).val
  obtain ⟨C, hC⟩ := degree_surjective
    (e.symm ⟨degreeJump a, Set.mem_Ici.mpr (degree_le_jump a)⟩)
  let S : ℕ → Oracle
    | 0 => B
    | 1 => C
    | n + 2 => W n
  let M := collapsed (ElementaryModel.hullSet (realSeed.{0} S))
  have hM : Transitive M := collapsed_transitive _
  have hT : SourceT M := collapsed_hull_sourceT _
  have hS (n : ℕ) : S n ∈ modelReals M :=
    (mem_collapsed _ _).mpr
      ⟨realCode (S n), seed_reals S n, (collapse_real_fixed S n).symm⟩
  obtain ⟨K, hK⟩ := ValidFirstUncountable.firstUncountable_exists M hM
    (collapsed_hull_valid (realSeed.{0} S)) ⟨realCode (S 0), hS 0⟩
  exact ⟨M, hM, hT, inferInstance, K, hK, (fun n => hS (n + 2)),
    ⟨B, hS 0, hB⟩, ⟨C, hS 1, hC⟩⟩

/-- Discharge the countable-test condition for an arbitrary global cone
isomorphism. No regularity or representation hypothesis is assumed. -/
theorem countable_tests {a : Degree} (e : Degree ≃o Set.Ici a) : CountableTests e := by
  intro W
  obtain ⟨M, hM, hT, hcount, K, hK, hWM, hpost, hpre⟩ :=
    covering_model_with_omega_one e W
  let := hcount
  have hcoords := product_mem M hM hT.pairing hT.union hT.powerSet
    hT.separation.finitePrefix.bounded hK.2.1 (sourceT_omega_mem M hM hT)
  obtain ⟨G, _, hG, hME, _, _, _⟩ :=
    CohenGroundGeneric.exists_extension M (ZFSet.prod K ZFSet.omega) hM hT hcoords ⊤
  obtain ⟨R, p, hR, hp⟩ :=
    ConePrescribedProgram.prescribed_program e M K hM hT hK hpost hpre G hG
  exact ⟨R, p, hR, fun n hn => hp (W n) (hME (hWM n)) hn⟩

/-- One fixed oracle program represents x |-> e.symm (a join x) on a set
of sufficiently generic inputs. -/
theorem generic_inverse_program {a : Degree} (e : Degree ≃o Set.Ici a) :
    InverseGenericProgramLift e :=
  generic_lift_of_countable_tests e (countable_tests e)

/-- No proper principal cone is order-isomorphic to all Turing degrees. -/
theorem cone_base_eq_bot {a : Degree} (e : Degree ≃o Set.Ici a) : a = ⊥ :=
  eq_bot_of_inverse_generic_program_lift e (generic_inverse_program e)

theorem no_nontrivial_cone_iso (a : Degree) (ha : a ≠ ⊥) :
    ¬ Nonempty (Degree ≃o Set.Ici a) := by
  rintro ⟨e⟩
  exact ha (cone_base_eq_bot e)

end
end OAI.TuringRigidity.ConeMain
