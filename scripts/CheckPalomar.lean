module

import Solution

/-! Audit the actual Solution environment, never the Challenge environment. -/

open OAI.TuringRigidity

example (a : Degree) (ha : a ≠ ⊥) :
    ¬ Nonempty (Degree ≃o Set.Ici a) :=
  ConeMain.no_nontrivial_cone_iso a ha

#check @ConeMain.no_nontrivial_cone_iso
#print axioms ConeMain.generic_inverse_program
#print axioms ConeMain.cone_base_eq_bot
#print axioms ConeMain.no_nontrivial_cone_iso
