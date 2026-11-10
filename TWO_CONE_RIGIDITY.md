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
persistent. The persistent-extension argument below strengthens this to an
extension that is itself persistent.

Base membership cannot be inferred merely from an isomorphism of two cone
intersections: both could be empty. Membership of both base jumps supplies
both bases. No separate 0' assumption is needed.

## Uniform arithmetic presentations

For a column presentation H of I, first use the joined graph

```
Graph rho H (i,j) <-> rho(a join deg(H_i)) = deg(H_j).
```

A relative successor/payload code records all joined inputs with parameters
between a and deg(H'). Transport through a larger extension sigma bounds them
by sigma(deg(H')). Agreement with rho fixes sigma^{-1}(b'), already bounded by
H. Five-jump locality gives `sigma(deg(H')) <= deg(H^(6))`; decoding yields a
single Sigma-5-in-H^(6) graph, recursive in H^(11).

`arithmetic_presentation_of_extension` only requires an extension whose
ambient ideal contains deg(H'). Neither that extension nor rho is assumed
persistent in this theorem. Persistence directly supplies such an extension.

The conventional partial graph is

```
RawGraph rho H (i,j) <-> exists x in I above a,
  x = deg(H_i) and rho(x) = deg(H_j).
```

It is the joined graph conjoined with `a <= deg(H_i)`. That source test is
Sigma-3 in the decoding oracle, so the same eleven-jump bound holds.

The joined graph determines rho even with repeated columns. Arithmetic graphs
form a countable collection; hence so do persistent partial maps when the two
base jumps lie in I. `arithmetic_restriction` gives a prescribed restriction,
both extension agreements, and its eleven-jump graph without assuming either
the larger map or its restriction persistent.

## Persistent extensions

`TuringTwoConePersistentExtension` uses the noncircular arithmetic restriction
lemma to prove:

If rho is persistent, I contains a' and b', and J is any prescribed countable
jump ideal containing I, then rho extends to a PERSISTENT map

```
sigma : Cone J a ≃o Cone J b.
```

The initial ideal need not be jump-closed. If it is, membership of a and b
suffices. No global map, Borel lift, or regularity hypothesis is used.

For the proof, fix a column presentation H of J and count ALL candidates with
graphs recursive in H^(11), not just the persistent ones. If no extension is
persistent, choose an obstructing degree for each candidate extending rho.
A single degree bounds these witnesses and deg(H'). Persistence of rho gives
a larger extension containing that bound. Its restriction to J has an
H^(11)-recursive graph without any persistence assumption, hence is one of
the candidates. The larger extension contains that candidate's own obstruction,
a contradiction.

Persistence is symmetric under inversion. The same persistent extension has
both conventional graph directions recursive in H^(11). Arbitrary persistent
partial maps also have persistent jump-closed extensions containing any
prescribed countable seed, not only restrictions of global maps.

`persistent_iff_arithmetic_extensions` characterizes persistence by existence
of H^(11)-recursive conventional graph extensions on every presented larger
countable jump ideal. This is a SEMANTIC equivalence. Turning it into a coded
Pi-1-1 formula requires reconstruction of actual maps from numerical graph
codes and remains a separate obligation.

## Remaining work

Code persistence and prove its absoluteness, adapt the forcing and
program-uniformity arguments, and discharge the generic-representation
assumption. Arithmetic presentations of countable partial maps do not
themselves give a global Borel representative. No unconditional pairwise-cone
rigidity theorem is asserted yet.

## Reproduction

```sh
lake build RequestProject.TuringTwoConeRepresentation RequestProject.TuringTwoConeLocality RequestProject.TuringTwoConePersistentExtension RequestProject.TuringConeMain
lake env lean scripts/CheckTwoConeRigidity.lean | tee two-cone-axioms.txt
lake env lean scripts/CheckTwoConeLocality.lean | tee two-cone-locality-axioms.txt
lake env lean scripts/CheckTwoConePresentation.lean | tee two-cone-presentation-axioms.txt
lake env lean scripts/CheckTwoConePersistence.lean | tee two-cone-persistence-axioms.txt
python3 scripts/check-axioms.py two-cone-axioms.txt two-cone-locality-axioms.txt two-cone-presentation-axioms.txt two-cone-persistence-axioms.txt
```

The dedicated audit includes exact-type examples and rejects axioms other than
`propext`, `Classical.choice`, and `Quot.sound`. It is a targeted dependency
build, not a rebuild of every historical target. The existing Palomar check
still compares the registered cone-vs-whole theorem, not the new unproved goal.
The registered Challenge, Solution, Comparator target, metadata, and original
source files remain unchanged. This branch is not a new Palomar submission.
