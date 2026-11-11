# Pairwise rigidity of principal Turing cones

## Endpoint and verification scope

The endpoint in `RequestProject/TuringTwoConeMain.lean`, in namespace
`OAI.TuringRigidity.TwoConeMain`, is:

```lean
theorem cones_orderIso_iff (a b : Degree) :
    Nonempty (Set.Ici a ≃o Set.Ici b) ↔ a = b
```

The same module supplies `cone_iso_apply_val`, `cone_automorphism_eq_refl`,
and `cone_iso_unique`. No regularity, persistence, determinacy, or model-existence
hypothesis occurs in their signatures. Verification status is recorded at the
exact head in PR #4 and CI; a proof file alone is not a verification claim.

The registered cone-versus-whole theorem, Challenge, Solution, Comparator target,
toolchain, metadata, and all pre-existing mathematical sources are unchanged.
The independent Comparator regression checks ONLY that registered theorem,
not this new pairwise-cone endpoint. No new registry submission or merge is
performed by these files.

## Analytic reduction and locality

For e from the cone above a to the cone above b, set g(x)=e^{-1}(b join x).
A Borel lift of g gives e(a join x) <= b join x, hence b <= a. Generic lifts
upgrade to Borel lifts. Applying this in both directions gives a=b and pointwise
identity. The conditional analytic modules retain their useful hypotheses;
`TwoConeMain` supplies the generic representation.

Relative bounded-code transport gives fifth-jump locality:

```
e(x)      <= (x join e^{-1}(b'))^(5),
e^{-1}(y) <= (y join e(a'))^(5).
```

The partial versions work in potentially different ordinary ideals. Every
countable jump ideal containing e(a') and e^{-1}(b') admits a persistent
restriction of the original global map.

## Arithmetic graphs, persistence, and absoluteness

For a presentation H of I containing a',b', the entire conventional graph of a
persistent partial two-cone map is recursive in H^(11). Code the joined-input
sequence with parameters below H'; transport bounds them by H^(6), and the
five-jump decoder gives the whole graph. The source-cone test adds no jump.
Repeated columns are allowed.

The extension-only theorem needs merely a larger map whose ordinary ideal
contains H', not persistence of that map. This avoids circularity in the
obstruction argument: count all H^(11)-recursive candidates, choose obstructions
for nonpersistent candidates, and restrict a persistent extension containing
their common bound. The resulting arithmetic candidate contradicts its own
obstruction. Persistent maps thus extend persistently on prescribed jump ideals.

Numerical action clauses reconstruct actual maps and exact conventional graphs.
Finite machine indices relative to H^(11) replace existential graph reals,
giving a uniform Pi-1-1 definition of persistence. The general arithmetic-tree
theorem gives internal/ambient agreement in suitable transitive SourceT models.
Extension witnesses have both their presentation and graph reals internal.

## Native graphs and descent

Internal real codes reconstruct the WHOLE ZFSet graph, with exactly the source
cone as domain. Collapse the OLD real family to obtain an internal presentation;
the arithmetic graph theorem reconstructs the same graph in every relevant
counting extension. The general bounded-subset intersection theorem descends it
into relative L(R), without assuming internal Choice there.

Persistent maps extend over arbitrary coded set forcing, with full graphs in
relative L(R), ground-model names, and one-real definitions at ordinal levels.
The names may depend on the generic filter and the definition real may be new.
None of these statements alone gives a global Borel representative.

## The joined-inverse graph and uniform program

`TuringTwoConePullbackProgram` defines the total joined inverse on the ordinary
ideal, with explicit target-base membership. Its values lie in the source cone;
no injectivity is assumed. Its semantics use the existing RELATION-ONLY compiler.
When the partial map restricts the original e, graph outputs and program outputs
are proved to agree with that same e.

`TuringTwoConePullbackDefinition` constructs this exact graph by bounded
separation from the forward graph, degree order, and target base b. Both bases
remain distinct. The existing weak-model join/order formulas are reused.

In a Cohen extension E, restrict the ORIGINAL e to its degree ideal, rather than
choose an unrelated extension of an old partial map. Fix an old real R of degree
e(a'). Every output on X reduces to (X join R)^(5). The existing real-parameter
transport and relation-only compiler absorb the new definition real into a
larger model and select one finite program with computational parameter R^(5).
No new compiler or implementation axiom is used.

The arithmetic SourceEquation is unchanged. Its degree-theoretic justification
uses a relative minimal pair over B join Y, where degree(B)=b. Ordinary lower
bounds need not be above a: `le_pullback_iff` joins them with a before applying e.
The existing generic triple construction and arithmetic truth-transfer theorem
then extend correctness from columns to sufficiently arithmetic-generic inputs
of the SAME extension.

## Globalization and conclusion

`TwoConeMain.covering_model_with_omega_one` constructs a countable transitive
model with an internal first uncountable ordinal, containing any prescribed
countable sequence of reals and both distinguished degrees. The prescribed
program handles all generic members of that sequence.

There are only countably many candidates (R,p), since R represents one fixed
degree and p is a finite program. Were every candidate to fail globally, choose
one bad generic input for each. A candidate handling that countable sequence
contradicts its own selected failure. This proves existence of fixed R,p with

```
degree(R)=e(a'), and for every X arithmetic-generic relative to R^(5),
p with oracle X join R^(5) is total and represents e^{-1}(b join degree(X)).
```

Selection is nonconstructive; this is not an effective algorithm that accepts
an arbitrary abstract isomorphism and prints a numerical program index.
`generic_inverse_program` gives the required dense-open lift. The analytic
argument in both directions yields the unconditional final endpoints.

## Reproduction

```sh
lake build RequestProject.TuringTwoConeMain RequestProject.TuringConeMain
lake env lean scripts/CheckTwoConeRigidity.lean | tee two-cone-axioms.txt
lake env lean scripts/CheckTwoConeLocality.lean | tee two-cone-locality-axioms.txt
lake env lean scripts/CheckTwoConePresentation.lean | tee two-cone-presentation-axioms.txt
lake env lean scripts/CheckTwoConePersistence.lean | tee two-cone-persistence-axioms.txt
lake env lean scripts/CheckTwoConeNumerical.lean | tee two-cone-numerical-axioms.txt
lake env lean scripts/CheckTwoConeSetGraphs.lean | tee two-cone-setgraphs-axioms.txt
lake env lean scripts/CheckTwoConeProgram.lean | tee two-cone-program-axioms.txt
python3 scripts/check-axioms.py two-cone-axioms.txt two-cone-locality-axioms.txt two-cone-presentation-axioms.txt two-cone-persistence-axioms.txt two-cone-numerical-axioms.txt two-cone-setgraphs-axioms.txt two-cone-program-axioms.txt
```

The final audit disables autoImplicit, checks exact unconditional theorem types,
and audits transitive axiom dependencies. Only propext, Classical.choice, and
Quot.sound are permitted. These are targeted dependency builds, not rebuilds
of every historical target. A Lean axiom report alone is not a separately
formalized derivation in ZFC.
