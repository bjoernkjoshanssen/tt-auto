import RequestProject.TuringConeIdealLocality
import RequestProject.TuringConePresentationCountability

/-!
# Persistent cone maps: prescribed extensions and arithmetic presentations

The starting ideal must contain both 0' and a'. Persistence first gives an
extension to a larger ideal. Two-sided locality then restricts that extension
to the prescribed jump ideal. Consequently the arithmetic-presentation theorem
no longer needs `HasJumpIdealExtension` as an additional hypothesis.

This is a theorem about countable partial maps. It is not yet the absoluteness
or forcing-extension theorem, nor a generic representative of a global map.
-/

namespace OAI.TuringRigidity.ConePersistentLocality

open OracleJump ArithmeticHierarchy PersistentRestrictions IdealInterpretation
open ConePersistence ConePresentation

noncomputable section

def unlift {I : CountableIdeal} {a : Degree} (ha : a ∈ I.carrier)
    (σ : PersistentLocality.ideal I ≃o Set.Ici (⟨a, ha⟩ : PersistentLocality.ideal I)) :
    I ≃o Cone I a :=
  (PersistentLocality.bridge I).trans (σ.trans (coneBridge I a ha).symm)

/-- A persistent cone map extends to any prescribed countable jump ideal
containing its domain, provided the domain contains the two required anchors. -/
theorem persistent_jump_extension {a : Degree} (I J : CountableIdeal)
    (ρ : I ≃o Cone I a) (hp : ConePersistence.Persistent I ρ)
    (hz : degree (jump FixedArithmetic.zero) ∈ I.carrier)
    (hza : degreeJump a ∈ I.carrier)
    (hIJ : I.carrier ⊆ J.carrier)
    (hjump : IdealLocality.JumpClosed (PersistentLocality.ideal J)) :
    ∃ σ : J ≃o Cone J a, ConePersistence.Extends hIJ ρ σ := by
  obtain ⟨b, hb⟩ := CountableBound.countable_bounded J.carrier J.countable
  obtain ⟨K, hIK, τ, hbK, he⟩ := hp b
  have hJK : J.carrier ⊆ K.carrier := fun x hx => K.lower (hb x hx) hbK
  have haI := ConePresentation.base_mem ρ
  have haJ := hIJ haI
  have haK := hIK haI
  let z₀ : I := ⟨degree (jump FixedArithmetic.zero), hz⟩
  let z₁ : Cone I a := ⟨degreeJump a, hza, degree_le_jump a⟩
  let α : PersistentLocality.ideal K := ⟨a, haK⟩
  let τ' := ConePresentation.lift τ haK
  let z₀K : PersistentLocality.ideal K := ⟨z₀.val, hIK z₀.property⟩
  let z₁K : Set.Ici α :=
    ⟨⟨z₁.val, hIK z₁.property.1⟩, Set.mem_Ici.mpr z₁.property.2⟩
  have hpost : ConeIdealCoding.image τ' z₀K ∈ J.carrier := by
    change (τ ⟨z₀.val, hIK z₀.property⟩).val ∈ J.carrier
    rw [he z₀]
    exact hIJ (ρ z₀).property.1
  have hpre : (τ'.symm z₁K).val ∈ J.carrier := by
    change (τ.symm ⟨z₁.val, hIK z₁.property.1, z₁.property.2⟩).val ∈ J.carrier
    rw [ConePersistence.extends_inverse he z₁]
    exact hIJ (ρ.symm z₁).property
  obtain ⟨σ, hσ⟩ := ConeIdealLocality.restrict_jump_ideal τ' z₀K rfl z₁K rfl
    hJK haJ hjump hpost hpre
  refine ⟨unlift haJ σ, ?_⟩
  intro x
  change ConeIdealCoding.image σ ⟨x.val, hIJ x.property⟩ = (ρ x).val
  exact (hσ ⟨x.val, hIJ x.property⟩).trans (he x)

/-- The explicit extension hypothesis from the previous milestone now follows
from persistence, with the additional `a'` membership stated openly. -/
theorem jump_extension_of_persistent {I : CountableIdeal} {a : Degree}
    (ρ : I ≃o Cone I a) (hp : ConePersistence.Persistent I ρ)
    {H : Oracle} (hpres : Presented I H)
    (hz : degree (jump FixedArithmetic.zero) ∈ I.carrier)
    (hza : degreeJump a ∈ I.carrier) : HasJumpIdealExtension ρ hpres :=
  persistent_jump_extension I (JumpIdeal.generated (degree H)) ρ hp hz hza
    (presentation_subset_generated hpres) (JumpIdeal.closed _)

/-- A single fixed finite-jump bound for the entire graph of a persistent map.
The presentation is uniform in both indices, but no uniform choice of a
representative for a global degree map is asserted. -/
theorem arithmetic_presentation_of_persistent {I : CountableIdeal} {a : Degree}
    (ρ : I ≃o Cone I a) (hp : ConePersistence.Persistent I ρ)
    {H : Oracle} (hpres : Presented I H)
    (hz : degree (jump FixedArithmetic.zero) ∈ I.carrier)
    (hza : degreeJump a ∈ I.carrier) :
    Sigma (iterate H 6) 5 (ConePresentation.Graph ρ hpres) ∧
      RecursivePred (iterate H 11) (ConePresentation.Graph ρ hpres) := by
  obtain ⟨σ, he⟩ := jump_extension_of_persistent ρ hp hpres hz hza
  let K := JumpIdeal.generated (degree H)
  have hIK : I.carrier ⊆ K.carrier := presentation_subset_generated hpres
  have haK := ConePresentation.base_mem σ
  let τ := ConePresentation.lift σ haK
  let z₁ : Cone I a := ⟨degreeJump a, hza, degree_le_jump a⟩
  let zK : Set.Ici (⟨a, haK⟩ : PersistentLocality.ideal K) :=
    ⟨⟨degreeJump a, hIK hza⟩, Set.mem_Ici.mpr (degree_le_jump a)⟩
  have hpre : (τ.symm zK).val ≤ degree H := by
    change (σ.symm ⟨z₁.val, hIK z₁.property.1, z₁.property.2⟩).val ≤ degree H
    rw [ConePersistence.extends_inverse he z₁]
    exact presentation_bound hpres (ρ.symm z₁).property
  have hH := self_mem_arithmeticIdeal H
  let b : arithmeticIdeal H := ⟨degree (jump H), (JumpIdeal.closed (degree H)) _ hH⟩
  have hbound : ConeIdealCoding.image τ b ≤ degree (iterate H 6) := by
    obtain ⟨X, Y, hX, hY, hXY⟩ := ConeIdealLocality.image_arithmetic τ zK rfl b
    have hYH : Reduces Y (jump H) := by
      change degree Y ≤ degree (jump H)
      rw [hY]
      exact sup_le le_rfl (hpre.trans (reduces_jump H))
    rw [← hX]
    exact reduces_trans hXY (iterate_mono hYH 5)
  obtain ⟨hg, hr⟩ := graph_sigma_of_bound τ H hH (presentation_bound hpres hz) b rfl
    (iterate H 6) (ConePresentation.reduces_iterate H 6) hbound
  have hgraph : ∀ v, IdealGraph τ H hH v ↔ ConePresentation.Graph ρ hpres v := by
    intro v
    change (σ ⟨degree (EncodedForcing.columns H (Nat.unpair v).1), _⟩).val =
      degree (EncodedForcing.columns H (Nat.unpair v).2) ↔ _
    exact Iff.of_eq (congrArg (fun x : Degree => x = degree (EncodedForcing.columns H (Nat.unpair v).2))
      (he (presentationEntry hpres (Nat.unpair v).1)))
  exact ⟨hg.congr hgraph, Form.congr (n := 0) (s := true) hr hgraph⟩

/-- Countability of persistent partial cone isomorphisms, without an extra
locality or jump-extension hypothesis. -/
theorem persistent_maps_countable (I : CountableIdeal) (a : Degree)
    (hz : degree (jump FixedArithmetic.zero) ∈ I.carrier)
    (hza : degreeJump a ∈ I.carrier) :
    {ρ : I ≃o Cone I a | ConePersistence.Persistent I ρ}.Countable := by
  obtain ⟨H, hpres⟩ := ConePresentation.presentation_exists I
  apply (recursive_maps_countable hpres (iterate H 11)).mono
  intro ρ hp
  exact (arithmetic_presentation_of_persistent ρ hp hpres hz hza).2

end
end OAI.TuringRigidity.ConePersistentLocality
