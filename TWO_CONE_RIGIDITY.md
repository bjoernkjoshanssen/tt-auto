# Toward pairwise non-isomorphism of Turing cones

The ultimate target is

```lean
Nonempty (Set.Ici a ≃o Set.Ici b) ↔ a = b
```

with eventual declaration name `cones_orderIso_iff`. This remains a goal, not
an unconditional theorem asserted by this branch. No placeholder or new axiom
asserts it. PR #4 and exact-head CI record verification status. The registered
cone-versus-whole theorem and its Challenge/Solution are unchanged.

## Analytic reduction and locality

Borel or generic inverse lifts in both directions imply equal bases and pointwise
identity. A single inverse lift gives `e(a join x) <= b join x`, hence `b <= a`.
The generic-to-Borel upgrade uses minimal pairs over the target base joined with
the input. Existence of the generic lift is still outstanding.

Bounded-code transport gives

```
rho(x)      <= (x join rho^{-1}(b'))^(5)
rho^{-1}(y) <= (y join rho(a'))^(5).
```

The two ordinary ambient ideals may differ. No jump preservation or regularity
is assumed. A common jump ideal containing both distinguished values is invariant.
For a global map, every countable such ideal supports a persistent restriction
of that SAME global map.

## Arithmetic graphs and persistent extensions

For a column presentation H of I containing a' and b', a persistent
`rho : Cone I a ≃o Cone I b` has its whole conventional graph recursive in
H^(11), and Sigma-5 in H^(6). Repeated columns are allowed. One relative
successor/payload code enumerates the joined inputs `a join deg(H_i)`, with
parameters below H'. Transport, five-jump locality, and five-jump decoding give
the graph bound. Adding the source-cone test does not increase the jump count.

The extension-only version needs just an extension on an ideal containing H'.
Neither map needs to be persistent there. This noncircular restriction lemma
and countability of arithmetic candidates yield persistent extensions on every
prescribed larger countable jump ideal. The same extension and its inverse have
eleven-jump graphs. If I is jump-closed, membership of a and b suffices. Base
membership is explicit: an isomorphism of two empty intersections supplies none.

## Numerical coding and absoluteness

Presentations and graphs are REALS. A finite machine index in Nat describes an
arithmetic graph RELATIVE to H^(11); it is not an absolute code for any real.
`TwoConeNumerical.Action` states numerical totality on the source cone, both cone
membership tests, surjectivity onto the target, order reflection, and saturation.
`reconstruct` produces the actual map and proves exact conventional graph
agreement. Numerical compatibility is equivalent to extension.

`TwoConeArithmeticCriterion` replaces existential graph reals by natural machine
indices. One natural k pairs the two base-column indices in a presentation A.
The semantic presentation property is equivalent to

```
forall H : Oracle, PresentationMatrix (parameters A R H) k,
```

with an arithmetic matrix. This is a proved uniform Pi-1-1 definition, using the
original development's complexity convention, not an additional axiom.

`TwoConeRealClosure` puts every persistent graph code into an appropriately closed
real collection containing its presentation. Extension witnesses have BOTH their
presentation and graph internal. `TwoConePersistenceAbsoluteness` reuses
`ArithmeticTree.sourceT_piOneOne_matrix` unchanged. `TwoConeInternalPersistence`
identifies the matrix with direct internal extension witnesses, whose domains
need not be jump-closed and whose maps are not assumed persistent. Suitable
transitive SourceT models agree on persistence and existence for fixed data.

## Native ZFSet reconstruction

`TuringTwoConeSetGraphs` defines the graph as the set of precisely the pairs
`(degreeSet x, degreeSet (rho x))` for x in the SOURCE cone. It is bounded by the
square of the ordinary ambient ideal; its domain is not replaced by that ideal.
Extensions give graph inclusion.

`action_eq_coneGraph` and `graphImage_action` quotient the internal real-valued
relation to exactly this native set graph. `coded_sets` proves that internal
presentation and graph codes give the entire internal graph, not merely
membership of each pair. It does not assume persistence or internal Choice.

`TuringTwoConeModelGraphs` discharges graph-code internality via the eleven-jump
bound for persistent maps. An internal enumeration of an old real family gives
the necessary presentation. Persistent extensions with internal ideal and full
graph can be chosen to contain any prescribed internal real.

## Collapse, descent, and relative L(R)

`TuringTwoConeForcingDescent` collapses the OLD real family, reconstructs the same
fixed graph in each relevant generic extension, and applies the existing general
bounded-subset intersection theorem. The result is membership of the entire graph
in the ground model. This stage does not assume Choice inside that model.

`TuringTwoConeConstructibleExtension` applies descent inside relative L(R).
For a countable transitive SourceT model M, a persistent map between the two cones
of its model ideal has its full graph in `relativeModel M (groundReals M)`.
Both bases must belong to the ideal; jump closure then supplies their jumps.
A persistent partial map with a',b' in its domain ideal extends to the full model
ideal with a graph in relative L(R), without prior internality of the initial map.
The existing finite-construction coding is applied to the same graph.

## Forcing names, definitions, and prescribed models

`TuringTwoConeForcingExtension` handles arbitrary coded set forcing over an
externally countable transitive SourceT model M. A persistent partial map on old
degrees extends to both cones of all degrees of E=M[G]. The extended graph lies
in relative L(R^E), hence in E, and has a forcing name encoded in M. The name may
depend on G; this is NOT yet a uniform name or generic oracle program.

`TuringTwoConeForcingDefinition` gives a definition of that same graph over an
ordinal level using one real parameter. The real may be in E, not M. Its coded
entry point starts with the model's direct real-coded persistence and derives
ambient persistence using the checked absoluteness theorem.

`TuringTwoConePrescribedModels` starts with any global isomorphism e and any
countable sequence of real inputs. A covering model need only contain real
representatives of e(a') and e^{-1}(b'), not the whole map as an internal parameter.
Locality supplies a persistent restriction of the ORIGINAL e, whose whole graph
is in the model's relative L(R). Model existence is a conclusion here.

## Remaining work

The uniform generic-program argument remains: define and represent the joined
inverse, control extension-real definition parameters, and prove agreement with
the original map on sufficiently generic inputs. Then discharge the analytic
representation hypothesis and assemble unconditional `cones_orderIso_iff` and
pointwise identity. Arithmetic graphs on countable ideals and model-level
one-real definitions alone do not give a global Borel representative.

## Reproduction

```sh
lake build RequestProject.TuringTwoConeRepresentation RequestProject.TuringTwoConePrescribedModels RequestProject.TuringConeMain
lake env lean scripts/CheckTwoConeRigidity.lean | tee two-cone-axioms.txt
lake env lean scripts/CheckTwoConeLocality.lean | tee two-cone-locality-axioms.txt
lake env lean scripts/CheckTwoConePresentation.lean | tee two-cone-presentation-axioms.txt
lake env lean scripts/CheckTwoConePersistence.lean | tee two-cone-persistence-axioms.txt
lake env lean scripts/CheckTwoConeNumerical.lean | tee two-cone-numerical-axioms.txt
lake env lean scripts/CheckTwoConeSetGraphs.lean | tee two-cone-setgraphs-axioms.txt
python3 scripts/check-axioms.py two-cone-axioms.txt two-cone-locality-axioms.txt two-cone-presentation-axioms.txt two-cone-persistence-axioms.txt two-cone-numerical-axioms.txt two-cone-setgraphs-axioms.txt
```

Audits include exact-type examples and reject axioms other than propext,
Classical.choice and Quot.sound. These are targeted dependency builds, not
rebuilds of every historical target. Palomar regression still checks the
registered theorem, not the unfinished pairwise-cone goal. Original mathematical
sources, Challenge, Solution, Comparator target and metadata remain unchanged.
