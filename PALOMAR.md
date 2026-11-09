# Mathematical account for the Palomar submission

## The result and its meaning

A real here is a subset of the natural numbers, represented by its Boolean
characteristic function. A set is Turing reducible to another when a computer
with membership-query access to the latter can decide membership in the former.
Two sets have the same Turing degree when each is reducible to the other. The
order of degrees records this relative computational power; its least element
is the degree of the computable sets.

For a Turing degree `a`, the principal upper cone `Set.Ici a` consists of all
degrees greater than or equal to `a`, including `a` itself. The compared theorem
states that, unless `a` is the computable degree, this ordered set is not
order-isomorphic to the whole ordered set of Turing degrees:

```lean
OAI.TuringRigidity.ConeMain.no_nontrivial_cone_iso
    (a : Degree) (ha : a ≠ ⊥) :
    ¬ Nonempty (Degree ≃o Set.Ici a)
```

The degrees are unrestricted degrees of sets, not merely computably enumerable
degrees. The structure has only its order; the isomorphism is not separately
assumed to preserve the jump, to be measurable, or to have a definable lift.
Since every degree is above bottom, `a ≠ ⊥` is equivalent to `a > ⊥`.

This is distinct from saying that every automorphism of the whole structure is
the identity. For example, the natural numbers with their usual order have no
nonidentity automorphism, yet shifting by one is an order isomorphism onto a
proper upper cone. Thus automorphism rigidity alone is not a formal
order-theoretic proof of the cone assertion.

## Independent statement surface

`Challenge.lean` imports only Mathlib. It defines characteristic functions,
ordinary `TuringReducible`, their quotient by mutual reducibility, the quotient
order, and the empty-set degree. These are concrete definitions, not arbitrary
axiomatized surrogates. It then states precisely the theorem above, leaving only
that theorem's proof as a deliberate placeholder.

`Solution.lean` exports the already proved declaration from
`RequestProject/TuringConeMain.lean`. It does not import Challenge. Comparator
checks the two environments, the stated theorem type, and permitted proof
axioms. This arrangement makes the advertised statement readable without
importing the many set-theoretic constructions used to prove it.

## Proof architecture

Suppose `e` is an order isomorphism from all degrees onto the cone above `a`,
and set `g(x) = e⁻¹(a ⊔ x)`. The decisive regularity theorem constructs a single
parameterized oracle program representing `g` on sufficiently generic inputs.
It is an existence-and-correctness result for a finite oracle-code type, not an
algorithm taking an arbitrary uncountable isomorphism as executable input.

The construction adapts coding and persistence methods to source and target
structures with different bottom elements. Two-sided arithmetic bounds use
the distinct parameters `e(0')` and `e⁻¹(a')`; equality of these parameters or
preservation of the jump is not assumed. Countable restrictions receive
arithmetic graph presentations, leading to persistent extensions, a coded
absoluteness argument, and constructibility of the appropriate degree graphs.
Cohen forcing and program selection provide one index rather than an unrelated
index for each input. The inverse-join map is treated as a relation, not as an
automorphism: in general it need not be injective.

The generic-to-global analytic step uses auxiliary minimal pairs over the join
of the cone base with the input. It yields a Borel inverse lift. Four-value
recovery and category avoidance give `e(x) ≤ a ⊔ x`. At `x = a`, this forces
`e(a) = a = e(⊥)`; injectivity then yields `a = ⊥`, the contradiction.

The detailed development and axiom audits are retained in the repository.
Intermediate lemmas can have explicit representation or model hypotheses;
the final theorem discharges them rather than retaining them as assumptions.

## Sources, authorship, and limits of the claim

The mathematical background is Theodore A. Slaman and W. Hugh Woodin,
*Definability in Degree Structures* (2005 manuscript), especially the
persistence and generic-representation arguments in Chapters 4–5:
<https://math.berkeley.edu/~slaman/talks/sw.pdf>.

The inherited formal infrastructure is OpenAI's DegreeRigidity development at
<https://github.com/openai/math/tree/fd4aeeb2ee4fc729c18d98444fed42fd0529eeeb/lean/OAI/Computability/DegreeRigidity>.
Its source tree matches the pre-Palomar inherited directory exactly, as
recorded in `OAI/PORTING.md`. The cone-specific argument was developed with
ChatGPT 6 Pro under Bjørn Kjos-Hanssen's mathematical direction. The initial
question and a suggested route also arose in private discussion. The original
Aristotle credit concerns earlier truth-table work and is retained separately.

The metadata's `original-proof` origin identifies where this cone-specific
argument is presented. It is not an independently reviewed assertion of
historical priority, and does not suggest that the background coding and
forcing methods are new. No source-author endorsement is claimed.

The theorem is formalized in classical Lean foundations with the standard
`propext`, `Classical.choice`, and `Quot.sound` dependencies. This is not a
separately formalized derivation in ZFC or ZF. Independent human review of the
mathematical interpretation and inherited machinery remains distinct from
successful kernel checking. Nor does preparing these files imply acceptance
or registration by Palomar; the submitted immutable commit must pass the
registry's own mechanical and editorial checks.
