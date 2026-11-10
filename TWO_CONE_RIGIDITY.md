# Toward pairwise non-isomorphism of Turing cones

The ultimate target is

```lean
Nonempty (Set.Ici a ≃o Set.Ici b) ↔ a = b
```

with the eventual declaration name `cones_orderIso_iff`. This unconditional
statement is still a goal, not a theorem asserted by this branch. No placeholder
proof or new axiom is used to assert it. Consult PR #4 and exact-head CI for
verification status. The registered cone-vs-whole result is unchanged.

## Analytic reduction and five-jump locality

The analytic modules prove equal bases and pointwise identity from explicit
Borel or generic inverse representatives in both directions. A single inverse
lift gives the sharp estimate `e(a join x) <= b join x` and therefore `b <= a`.
The generic-to-Borel step uses minimal pairs over the target base plus the input.
The representation assumption in `cones_orderIso_iff_of_generic_representation`
is still outstanding.

The bounded-code modules transport antichain, set, relation, and unary-predicate
codes between cones of ordinary degree ideals. Empty joins use the cone base;
all code parameters have explicit lower and upper bounds. The two ordinary
ambient ideals may differ. The proved pointwise estimates are

```
rho(x)     <= (x join rho^{-1}(b'))^(5)
rho^{-1}(y) <= (y join rho(a'))^(5).
```

Neither regularity nor preservation of jump is assumed. For a global map,
one fixed oracle P representing e(a') bounds every inverse output by
`(Y join P)^(5)`, but this does not yet select one program uniformly in Y.

## Partial maps and locality

Partial maps have type `Cone I a ≃o Cone I b`, where I is an ordinary countable
degree ideal. Closing any countable seed under the two joined maps, joins,
jumps, and downward reducibility gives a persistent restriction of a global
map. Any countable jump ideal containing e(a') and e^{-1}(b') already supports
such a restriction of that very global map.

If a persistent partial map starts on an ideal containing a' and b', locality
restricts a larger extension to any prescribed larger countable jump ideal.
Both extension agreements are retained, without assuming the larger map
persistent. This does not yet prove that the restriction can be persistent.

Base membership cannot be inferred merely from an isomorphism of two cone
intersections: both could be empty. Membership of both base jumps supplies
both bases. No separate 0' assumption is needed.

## Uniform arithmetic presentations

The presentation files code a whole sequence at once, not just each value
separately. For a column presentation H of I, initially use the joined graph

```
Graph rho H (i,j) <-> rho(a join deg(H_i)) = deg(H_j).
```

The relative enumeration construction records all joined inputs in one
successor/payload code, with all parameters between a and deg(H'). The joined
inputs cover the source cone even if columns repeat. Transport through a larger
extension sigma bounds the parameters by sigma(deg(H')). Agreement with rho
fixes sigma^{-1}(b'), which is already bounded by H. Five-jump locality gives
`sigma(deg(H')) <= deg(H^(6))`; five-jump decoding then gives

```
Graph rho H is Sigma-5 in H^(6), and recursive in H^(11).
```

`arithmetic_presentation_of_extension` only requires an extension whose
ambient ideal contains deg(H'). Neither that extension nor rho is assumed
persistent in this theorem. `arithmetic_presentation_of_persistent` obtains
such an extension directly from persistence. There is no separate jump-ideal
extension or graph-definability hypothesis.

`TuringTwoConeGraphPresentation` also handles the conventional partial graph:

```
RawGraph rho H (i,j) <-> exists x in I above a,
  x = deg(H_i) and rho(x) = deg(H_j).
```

It is the joined graph conjoined with the source-cone test `a <= deg(H_i)`.
That test is Sigma-3 in the decoding oracle, so the conventional graph has
the SAME Sigma-5-in-H^(6) and recursive-in-H^(11) bounds.

The joined graph determines rho. Consequently the arithmetic maps on one
presented ideal form a countable set, and `persistent_maps_countable` proves
countability of all persistent partial maps when a' and b' belong to I.
`arithmetic_restriction` supplies a prescribed restriction, both extension
agreements, and its eleven-jump graph without assuming the larger map persistent.
This is the noncircular input for the next obstruction argument.

## Remaining work

Choose extensions that remain persistent, code persistence and prove its
absoluteness, adapt the forcing and program-uniformity arguments, and discharge
the generic-representation assumption. Arithmetic presentations of countable
partial maps do not themselves give a global Borel representative.

## Reproduction

```sh
lake build RequestProject.TuringTwoConeRepresentation RequestProject.TuringTwoConeLocality RequestProject.TuringTwoConeGraphPresentation RequestProject.TuringConeMain
lake env lean scripts/CheckTwoConeRigidity.lean | tee two-cone-axioms.txt
lake env lean scripts/CheckTwoConeLocality.lean | tee two-cone-locality-axioms.txt
lake env lean scripts/CheckTwoConePresentation.lean | tee two-cone-presentation-axioms.txt
python3 scripts/check-axioms.py two-cone-axioms.txt two-cone-locality-axioms.txt two-cone-presentation-axioms.txt
```

The dedicated audit includes exact-type examples and rejects axioms other than
`propext`, `Classical.choice`, and `Quot.sound`. It is a targeted dependency
build, not a rebuild of every historical target. The existing Palomar check
still compares the registered cone-vs-whole theorem, not the new unproved goal.
The registered Challenge, Solution, Comparator target, metadata, and original
source files remain unchanged. This branch is not a new Palomar submission.
