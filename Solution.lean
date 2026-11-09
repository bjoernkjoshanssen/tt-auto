module

public import RequestProject.TuringConeMain

/-!
# Solution to the Palomar cone-rigidity challenge

The public import exports the existing proved declaration
`OAI.TuringRigidity.ConeMain.no_nontrivial_cone_iso` unchanged. In particular,
this file does not import `Challenge`, use its deliberate proof hole, or
introduce a new axiom. Comparator compares the exported theorem with the
independent Mathlib-only statement in `Challenge.lean`.
-/

#check OAI.TuringRigidity.ConeMain.no_nontrivial_cone_iso
