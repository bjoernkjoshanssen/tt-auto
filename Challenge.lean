module

public import Mathlib

/-!
# Pairwise rigidity of principal upper cones of Turing degrees

This independent statement imports only Mathlib, never the proof development.
An oracle is a subset of the natural numbers, represented by a Boolean
characteristic function. Reducibility is ordinary Turing reducibility; degrees
are the quotient by mutual reducibility, with their usual order.

The elementary join construction is included because the solution obtains its
order instance through `SemilatticeSup Degree`. Reproducing that concrete
instance keeps Comparator's statement comparison exact. It is the usual
interleaving of two sets, not an additional mathematical assumption.
All supporting claims below are proved. Only the two final Challenge proofs
are omitted; this module is not imported by Solution.

For a degree a, Set.Ici a is the principal upper cone with its inherited order.
The first theorem says that two such cones are order-isomorphic exactly when
their bases agree. The second says that every such isomorphism fixes each
underlying degree; in particular every individual cone has only the identity
automorphism. Both apply to arbitrary order isomorphisms, with no regularity,
determinacy, persistence, or model-existence premise.
See formalization.yaml and PALOMAR.md for provenance, AI use, and limitations.
-/

set_option backward.privateInPublic true
set_option backward.proofsInPublic true

@[expose] public section
namespace OAI.TuringRigidity

abbrev Oracle := ℕ → Bool

def oracleFunction (A : Oracle) : ℕ →. ℕ := fun n => Part.some (if A n then 1 else 0)

def Reduces (A B : Oracle) : Prop := TuringReducible (oracleFunction A) (oracleFunction B)

instance : IsPreorder Oracle Reduces where
  refl A := TuringReducible.refl (oracleFunction A)
  trans _ _ _ h k := TuringReducible.trans h k

def Degree := Antisymmetrization Oracle Reduces

instance : PartialOrder Degree :=
  @instPartialOrderAntisymmetrization Oracle
    { le := Reduces
      lt A B := Reduces A B ∧ ¬ Reduces B A
      lt_iff_le_not_ge _ _ := Iff.rfl
      le_refl A := TuringReducible.refl (oracleFunction A)
      le_trans _ _ _ h k := TuringReducible.trans h k }

theorem reduces_trans {A B C : Oracle} (h : Reduces A B) (k : Reduces B C) :
    Reduces A C := TuringReducible.trans h k

def degree (A : Oracle) : Degree := toAntisymmetrization Reduces A

theorem degree_eq_iff (A B : Oracle) :
    degree A = degree B ↔ Reduces A B ∧ Reduces B A := by
  exact Quotient.eq

theorem degree_surjective : Function.Surjective degree := by
  intro a
  exact ⟨ofAntisymmetrization Reduces a, toAntisymmetrization_ofAntisymmetrization _ a⟩

/-- The ordinary Turing join, interleaving characteristic functions. -/
def join (A B : Oracle) (n : ℕ) : Bool := if n.bodd then B (n / 2) else A (n / 2)

private theorem total_comp {O : Set (ℕ →. ℕ)} {f g : ℕ → ℕ}
    (hf : Nat.RecursiveIn O (fun n => Part.some (f n)))
    (hg : Nat.RecursiveIn O (fun n => Part.some (g n))) :
    Nat.RecursiveIn O (fun n => Part.some (f (g n))) := by
  simpa using Nat.RecursiveIn.comp hf hg

private theorem total_pair {O : Set (ℕ →. ℕ)} {f g : ℕ → ℕ}
    (hf : Nat.RecursiveIn O (fun n => Part.some (f n)))
    (hg : Nat.RecursiveIn O (fun n => Part.some (g n))) :
    Nat.RecursiveIn O (fun n => Part.some (Nat.pair (f n) (g n))) := by
  simpa [Seq.seq] using Nat.RecursiveIn.pair hf hg

private theorem total_primrec {O : Set (ℕ →. ℕ)} {f : ℕ → ℕ}
    (hf : Primrec f) : Nat.RecursiveIn O (fun n => Part.some (f n)) :=
  RecursiveIn.iff_nat.mp hf.computableIn

@[simp] theorem join_even (A B : Oracle) (n : ℕ) : join A B (2*n) = A n := by
  simp [join, Nat.bodd_mul]

@[simp] theorem join_odd (A B : Oracle) (n : ℕ) : join A B (2*n+1) = B n := by
  simp [join, Nat.bodd_mul]
  congr 1
  omega

theorem reduces_join_left (A B : Oracle) : Reduces A (join A B) := by
  apply RecursiveIn.iff_nat.mpr
  have horacle : Nat.RecursiveIn {oracleFunction (join A B)} (oracleFunction (join A B)) :=
    .oracle _ (Set.mem_singleton _)
  have h := total_comp horacle (total_primrec (Primrec.nat_mul.comp (Primrec.const 2) Primrec.id))
  change Nat.RecursiveIn {oracleFunction (join A B)} (fun n => Part.some (if A n then 1 else 0))
  simpa [oracleFunction] using h

theorem reduces_join_right (A B : Oracle) : Reduces B (join A B) := by
  apply RecursiveIn.iff_nat.mpr
  have horacle : Nat.RecursiveIn {oracleFunction (join A B)} (oracleFunction (join A B)) :=
    .oracle _ (Set.mem_singleton _)
  have h := total_comp horacle (total_primrec
    (Primrec.nat_add.comp (Primrec.nat_mul.comp (Primrec.const 2) Primrec.id) (Primrec.const 1)))
  change Nat.RecursiveIn {oracleFunction (join A B)} (fun n => Part.some (if B n then 1 else 0))
  simpa [oracleFunction] using h

private def selectPair (k : ℕ) : ℕ :=
  if (Nat.unpair k).1.bodd then (Nat.unpair (Nat.unpair k).2).2
  else (Nat.unpair (Nat.unpair k).2).1

private theorem selectPair_primrec : Primrec selectPair := by
  apply (Primrec.cond (Primrec.nat_bodd.comp (Primrec.fst.comp Primrec.unpair))
    (Primrec.snd.comp (Primrec.unpair.comp (Primrec.snd.comp Primrec.unpair)))
    (Primrec.fst.comp (Primrec.unpair.comp (Primrec.snd.comp Primrec.unpair)))).of_eq
  intro n
  cases hb : (Nat.unpair n).1.bodd <;> simp [selectPair, hb]

theorem join_reduces {A B C : Oracle} (hA : Reduces A C) (hB : Reduces B C) :
    Reduces (join A B) C := by
  apply RecursiveIn.iff_nat.mpr
  have hA' := RecursiveIn.iff_nat.mp hA
  have hB' := RecursiveIn.iff_nat.mp hB
  have hdiv : Nat.RecursiveIn {oracleFunction C} (fun n => Part.some (n / 2)) :=
    total_primrec (Primrec.nat_div.comp Primrec.id (Primrec.const 2))
  have hp := total_pair (total_primrec Primrec.id)
    (total_pair (total_comp hA' hdiv) (total_comp hB' hdiv))
  have h := total_comp (total_primrec selectPair_primrec) hp
  apply Nat.RecursiveIn.of_eq h
  intro n
  simp only [selectPair, Nat.unpair_pair, oracleFunction, join, id_eq]
  by_cases hb : n.bodd = true <;> simp [hb]

theorem join_mono {A B C D : Oracle} (hA : Reduces A C) (hB : Reduces B D) :
    Reduces (join A B) (join C D) :=
  join_reduces (reduces_trans hA (reduces_join_left C D))
    (reduces_trans hB (reduces_join_right C D))

def degreeJoin (a b : Degree) : Degree :=
  Quotient.liftOn₂ a b (fun A B => degree (join A B))
    (fun _ _ _ _ hA hB => (degree_eq_iff _ _).mpr
      ⟨join_mono hA.1 hB.1, join_mono hA.2 hB.2⟩)

instance : SemilatticeSup Degree where
  sup := degreeJoin
  le_sup_left a b := by
    obtain ⟨A, rfl⟩ := degree_surjective a
    obtain ⟨B, rfl⟩ := degree_surjective b
    exact reduces_join_left A B
  le_sup_right a b := by
    obtain ⟨A, rfl⟩ := degree_surjective a
    obtain ⟨B, rfl⟩ := degree_surjective b
    exact reduces_join_right A B
  sup_le a b c := by
    obtain ⟨A, rfl⟩ := degree_surjective a
    obtain ⟨B, rfl⟩ := degree_surjective b
    obtain ⟨C, rfl⟩ := degree_surjective c
    exact join_reduces

/-- The computable degree, represented by the empty set. -/
instance : OrderBot Degree where
  bot := degree (fun _ => false)
  bot_le a := by
    obtain ⟨A, rfl⟩ := degree_surjective a
    apply RecursiveIn.iff_nat.mpr
    change Nat.RecursiveIn {oracleFunction A} (fun _ => Part.some 0)
    exact .zero

/-- Two principal upper cones are order-isomorphic exactly when their bases agree. -/
theorem TwoConeMain.cones_orderIso_iff (a b : Degree) :
    Nonempty (Set.Ici a ≃o Set.Ici b) ↔ a = b := by
  sorry

/-- Every isomorphism between principal upper cones fixes each underlying degree. -/
theorem TwoConeMain.cone_iso_apply_val {a b : Degree}
    (e : Set.Ici a ≃o Set.Ici b) (x : Set.Ici a) :
    (e x).val = x.val := by
  sorry

end OAI.TuringRigidity
