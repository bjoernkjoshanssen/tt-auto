# Toward pairwise non-isomorphism of Turing cones

This separate development targets

```lean
Nonempty (Set.Ici a ≃o Set.Ici b) ↔ a = b
```

with the eventual declaration name `cones_orderIso_iff`. The unconditional
statement is a goal, NOT a theorem claimed by this branch yet. No placeholder
proof or new axiom is used to assert it. Consult PR #4 and the exact-head CI
runs for the verification status of each milestone.

## Analytic milestone

The analytic modules assume an explicit Borel or generic program lift of
`x ↦ (e.symm (b ⊔ x)).val` for an isomorphism from the cone above `a` onto the
cone above `b`. One such inverse lift gives `e (a ⊔ x) ≤ b ⊔ x` and hence
`b ≤ a`. Lifts in both directions give equal bases and pointwise identity.
Generic continuous/program lifts are upgraded to global Borel lifts using
minimal pairs over the target base joined with the input.

The remaining representation hypothesis is explicit in
`cones_orderIso_iff_of_generic_representation`; it must not be dropped when
reporting this theorem.

## Bounded codes and five-jump locality

`TuringTwoConeIdealCodes` interprets antichain, set and relation codes inside
principal cones of ordinary ideals. Quantifiers are related to their ambient
cone meanings using the code bounds. Empty finite joins retain the base.
`TuringTwoConeIdealCopies` lifts bounded external codes into these structures
and transports copies of unary predicates, retaining the identical predicate
on the standard natural numbers and bounds on all parameters.

`TuringTwoConeIdealLocality` applies the existing relative coding and decoder
on opposite sides of an isomorphism. The ambient ideals may differ. For
`rho : (I intersect Ici a) ≃o (J intersect Ici b)`, the estimates are

```
rho(x)     <= (x join rho^{-1}(b'))^(5)
rho^{-1}(y) <= (y join rho(a'))^(5).
```

Here the notation means five iterations of the ordinary Turing jump. The
base jumps must belong to their respective ideals. No preservation of jump,
persistence, Borelness, or generic representation is assumed.

A common intermediate jump ideal containing both distinguished values is
invariant in the two-cone sense. `restrict_jump_ideal` constructs the actual
restricted order isomorphism, not just forward containment.

`TuringTwoConeLocality` specializes these results to global cone maps. For a
fixed oracle P representing e(a'), every representative X of the joined
inverse at deg(Y) satisfies X <=T (Y join P)^(5). The reduction index is not
asserted to be uniform in Y. A countable jump ideal containing e(a') and
 e^{-1}(b') carries a persistent restriction of the original global map.

## Persistence and prescribed domains

Partial maps have type `Cone I a ≃o Cone I b`, with I an ordinary countable
ideal. From an arbitrary global isomorphism and a countable seed, closure
under the joined maps, finite joins, jump and downward reducibility gives
a countable invariant jump ideal and a persistent restriction.

`TuringTwoConePersistentLocality` proves that a persistent partial map extends
to exactly any prescribed countable jump ideal containing its original ideal,
provided the original ideal contains both a' and b'. Locality restricts an
arbitrary larger extension, and both extension agreements are retained.
In particular this supplies the extension to the ideal of degrees arithmetic
in a column presentation H of I. That is NOT yet an arithmetic presentation
of the entire graph of the map.

The smaller ideal need not itself be jump-closed. If it is, it is enough to
assume both bases belong to it. Unlike the one-cone-versus-whole case, an
isomorphism of two cone intersections by itself does not imply base membership:
both intersections could be empty. No separate 0' membership assumption is
needed.

The prescribed extension is not yet asserted to be persistent. Proving that
stronger result requires the arithmetic graph/countability argument.

## Remaining stages

Uniform arithmetic presentations and countability of partial maps; persistent
extensions which remain persistent; coded complexity and absoluteness; and the
model/forcing and program-uniformity arguments. The pointwise five-jump bound
is proved without regularity, but it does not imply a Borel choice of witnesses.
No eleven-jump (or twelve-jump) whole-graph bound is claimed for two cones yet.

## Checks

```sh
lake build RequestProject.TuringTwoConeRepresentation RequestProject.TuringTwoConeLocality RequestProject.TuringConeMain
lake env lean scripts/CheckTwoConeRigidity.lean | tee two-cone-axioms.txt
lake env lean scripts/CheckTwoConeLocality.lean | tee two-cone-locality-axioms.txt
python3 scripts/check-axioms.py two-cone-axioms.txt two-cone-locality-axioms.txt
```

The dedicated checks include exact-type examples and transitive axiom audits.
They reject every axiom other than propext, Classical.choice and Quot.sound.
The registered Challenge, Solution, Comparator target, metadata, and existing
cone proof are unchanged. This branch is not a new Palomar submission.
