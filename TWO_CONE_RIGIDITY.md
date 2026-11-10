# Toward pairwise non-isomorphism of Turing cones

This separate development targets

```lean
Nonempty (Set.Ici a ≃o Set.Ici b) ↔ a = b
```

with the eventual declaration name `cones_orderIso_iff`. The unconditional
statement is a goal, NOT a theorem claimed by this branch yet. No placeholder
proof or new axiom is used to assert it.

## Analytic milestone

The new analytic modules assume an explicit Borel or generic program lift of
`x ↦ (e.symm (b ⊔ x)).val` for an isomorphism from the cone above `a` onto the
cone above `b`. One such inverse lift gives `e (a ⊔ x) ≤ b ⊔ x` and hence
`b ≤ a`. Lifts in both directions give equal bases and pointwise identity.
Generic continuous/program lifts are upgraded to global Borel lifts using
minimal pairs over the target base joined with the input.

The remaining representation hypothesis is explicit in
`cones_orderIso_iff_of_generic_representation`; it must not be dropped when
reporting this theorem.

## Initial persistence infrastructure

Partial maps have type `Cone I a ≃o Cone I b`, with `I` an ordinary countable
ideal. From an arbitrary global isomorphism and a countable seed, closure
under the two joined maps, finite joins, jump and downward reducibility gives
a countable jump ideal containing both bases and a persistent restriction.
Forward extension agreement is proved to imply inverse agreement. Persistence
also allows any prescribed countable set to be included in an extension.
These results assume no regularity of the global map.

This is NOT yet an arithmetic-presentation theorem, a persistent-extension
theorem for arbitrary partial maps, or a forcing theorem.

## Next stages

Generalize relative coding, locality, arithmetic presentations and persistence
to partial maps `I ∩ Ici a` isomorphic to `I ∩ Ici b`, followed by the
model/forcing and program-uniformity arguments. The natural anchors are
`e(a')` and `e.symm(b')`. No increased jump bound is asserted without proof.

## Checks

```sh
lake build RequestProject.TuringTwoConeRepresentation RequestProject.TuringTwoConePersistence RequestProject.TuringConeMain
lake env lean scripts/CheckTwoConeRigidity.lean | tee two-cone-axioms.txt
python3 scripts/check-axioms.py two-cone-axioms.txt
```

The registered Challenge, Solution, Comparator target, metadata, and existing
cone proof are unchanged. New theorem signatures and transitive axiom audits
are checked separately. This branch is not a new Palomar submission.
