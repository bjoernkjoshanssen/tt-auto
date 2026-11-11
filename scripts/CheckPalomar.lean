module

public import Solution

@[expose] public section
set_option autoImplicit false

open OAI.TuringRigidity

#print axioms TwoConeMain.cones_orderIso_iff
#print axioms TwoConeMain.cone_iso_apply_val

/-- Exact unconditional types for both independently compared statements. -/
example (a b : Degree) : Nonempty (Set.Ici a ≃o Set.Ici b) ↔ a = b :=
  TwoConeMain.cones_orderIso_iff a b

example {a b : Degree} (e : Set.Ici a ≃o Set.Ici b) (x : Set.Ici a) :
    (e x).val = x.val := TwoConeMain.cone_iso_apply_val e x

/-- The second compared result implies rigidity of every individual cone. -/
example (a : Degree) (e : Set.Ici a ≃o Set.Ici a) :
    e = OrderIso.refl (Set.Ici a) := by
  apply DFunLike.ext
  intro x
  exact Subtype.ext (TwoConeMain.cone_iso_apply_val e x)
