# Toward pairwise non-isomorphism of Turing cones

The ultimate target is

```lean
Nonempty (Set.Ici a ≃o Set.Ici b) ↔ a = b
```

with eventual declaration name `cones_orderIso_iff`. This remains a goal, not
an unconditional theorem asserted by this branch. No placeholder or new axiom
asserts it. PR #4 and its exact-head CI record which stages have been verified.
The registered cone-versus-whole result is unchanged.

## Analytic reduction and locality

Borel or generic inverse lifts in both directions imply equal bases and
pointwise identity. A single inverse lift gives `e(a join x) <= b join x`, hence
`b <= a`. The generic-to-Borel upgrade uses minimal pairs over the target base
joined with the input. Existence of the generic lift remains outstanding.

Bounded-code transport between cones in ordinary ideals gives

```
rho(x)      <= (x join rho^{-1}(b'))^(5)
rho^{-1}(y) <= (y join rho(a'))^(5).
```

The ambient ideals may differ. No jump preservation or regularity is assumed.
A common jump ideal containing both distinguished values is invariant in the
two-cone sense. For a global map, every countable such ideal supports a persistent
restriction of that same global map.

## Arithmetic presentations and persistent extensions

For a presentation H of I containing a' and b', a persistent map
`rho : Cone I a ≃o Cone I b` has its entire conventional indexed graph recursive
in H^(11), and Sigma-5 in H^(6). Repeated columns are allowed. First code the
joined input sequence `a join deg(H_i)` using one successor/payload enumeration
bounded by H'. Transport bounds its parameters by the image of H', which
five-jump locality bounds by H^(6). A five-jump decoder gives the whole graph.
The source-cone membership test adds no jump.

The extension-only version needs merely an extension on an ideal containing
H'; neither map needs to be persistent. This provides the noncircular restriction
lemma used in the obstruction proof of persistent extensions.

A persistent partial map extends persistently to every prescribed larger
countable jump ideal. If the starting ideal is jump-closed, explicit membership
of both bases suffices. Two empty cone intersections can be isomorphic, so base
membership is not inferred from an isomorphism alone. No separate 0' assumption
is used. The same extension and its inverse both have eleven-jump graphs.

## Numerical codes: what is and is not a natural number

The presentation H and graph R are reals. Their individual column and pair
indices are natural numbers. Once a graph is recursive in H^(11), one ordinary
finite machine code e in Nat specifies it RELATIVE to H^(11). This is not an
absolute natural-number code for an arbitrary real, nor an effective procedure
for recovering e from a completely abstract isomorphism.

`TuringTwoConeNumerical` uses conventional partial graphs. Its `Action B C H P`
requires totality only on columns above deg(B), all graph pairs to lie in the
source and target cones, surjectivity onto columns above deg(C), order reflection,
and saturation under repeated output degrees. These are numerical conditions,
not an assumption that a map exists. `reconstruct` produces the actual order
isomorphism and proves exact graph agreement. Numerical compatibility is proved
equivalent to extension of actual maps.

`TuringTwoConeArithmeticCriterion` proves all these conditions uniformly
arithmetic. A natural k pairs the two base-column indices in the original
presentation A. For every larger jump-ideal presentation H the criterion asks
for a natural machine index e, whose H^(11)-table graph is an action compatible
with the original graph R. The criterion is proved equivalent to persistence.

`TuringTwoConePersistenceComplexity` includes validity of the original ideal,
both base jumps, and graph. Its semantic `Property A R k` is identified with

```
forall H : Oracle, PresentationMatrix (parameters A R H) k,
```

where the matrix is proved `Arith`. Thus this is a uniform Pi-1-1 normal form in
the original development's complexity convention, not a new complexity axiom.

## Model comparison and internal witnesses

`TuringTwoConeRealClosure` uses the eleven-jump bound to put persistent graph
codes into any appropriately closed real collection containing the presentation.
It also produces extension witnesses with BOTH presentation and graph internal.

`TuringTwoConePersistenceAbsoluteness` applies the existing general theorem
`ArithmeticTree.sourceT_piOneOne_matrix` unchanged. For transitive SourceT models
containing A and R, internal interpretation of the matrix agrees with ambient
persistence. All persistent graph codes already belong to such a model if A
does, so existence of a persistent graph is absolute as well.

`TuringTwoConeInternalPersistence` connects the matrix to the direct statement:
every real in the model has an extension with presentation and graph codes in
the model. Those extension ideals need not be jump-closed, and those extension
maps are NOT assumed persistent. The forward implication uses arithmetic
restriction without circularity; the reverse uses persistent extensions and
closure. Two suitable transitive models agree on this real-coded property even
when their real collections differ and neither model contains the other.

These are results about real-coded countable maps. They do not yet construct
native ZFSet graphs, extend global maps through forcing, or produce the generic
program needed for unconditional pairwise cone rigidity.

## Remaining work

Native set-graph reconstruction, model/forcing descent, and the generic-program
uniformity argument; then discharge the representation hypothesis and assemble
unconditional `cones_orderIso_iff` and pointwise identity. Arithmetic graphs on
countable ideals alone do not give a global Borel representative.

## Reproduction

```sh
lake build RequestProject.TuringTwoConeRepresentation RequestProject.TuringTwoConeLocality RequestProject.TuringTwoConeInternalPersistence RequestProject.TuringConeMain
lake env lean scripts/CheckTwoConeRigidity.lean | tee two-cone-axioms.txt
lake env lean scripts/CheckTwoConeLocality.lean | tee two-cone-locality-axioms.txt
lake env lean scripts/CheckTwoConePresentation.lean | tee two-cone-presentation-axioms.txt
lake env lean scripts/CheckTwoConePersistence.lean | tee two-cone-persistence-axioms.txt
lake env lean scripts/CheckTwoConeNumerical.lean | tee two-cone-numerical-axioms.txt
python3 scripts/check-axioms.py two-cone-axioms.txt two-cone-locality-axioms.txt two-cone-presentation-axioms.txt two-cone-persistence-axioms.txt two-cone-numerical-axioms.txt
```

Audits include exact-type examples and reject axioms other than propext,
Classical.choice and Quot.sound. These are targeted dependency builds, not
rebuilds of every historical target. Palomar regression still checks the
registered theorem, not the unfinished pairwise-cone goal. Original mathematical
sources, Challenge, Solution, Comparator target and metadata remain unchanged.
