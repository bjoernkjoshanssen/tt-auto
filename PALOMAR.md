# Palomar submission: Turing cone rigidity

## Statement of record

The single selected declaration is

```lean
OAI.TuringRigidity.ConeMain.no_nontrivial_cone_iso
```

It says that for every nonzero Turing degree `a`, there is no order isomorphism
from all Turing degrees onto the principal upper cone `{x : Degree // a ≤ x}`.
It is an order-theoretic assertion, not merely a prohibition on continuous or
Borel isomorphisms. There is no determinacy, measurability or representation
hypothesis in the final statement.

`Challenge.lean` independently defines the ordinary notions using Mathlib:
Boolean characteristic functions, Turing reducibility, the quotient by mutual
reducibility, its induced order, and the computable bottom degree. It imports
no local proof file. Its one deliberate `sorry` is the theorem to be checked.
`Solution.lean` imports the existing proved declaration with the same fully
qualified name. Neither module imports the other. Comparator must verify that
the theorem and all statement dependencies agree; a matching spelling alone
would not be sufficient.

## Mathematical account

Suppose `e : Degree ≃o Set.Ici a`. Set `g(x) = e⁻¹(a ⊔ x)`. The development
adapts bounded degree coding and arithmetic presentations to partial cone
isomorphisms. Persistence and its absoluteness give suitable countable model
restrictions. Graph reconstruction in counting extensions and descent into
relative `L(R)` supply definitions for those restrictions.

Cohen forcing and program selection then produce one fixed oracle program for
`g` on sufficiently generic inputs. The parameter is a finite jump of a
representative of `e(0')`; the program does not depend on the varying input.
The relative minimal-pair calculation is over `A ⊕ X`, where `deg(A) = a`.
A countable-candidate diagonalization gives a global generic representative.
The analytic recovery argument upgrades it to a Borel inverse lift and proves
`e(x) ≤ a ⊔ x`. At `x = a`, this gives `e(a) = a = e(0)`, so injectivity forces
`a = 0`.

The proof builds on the upstream OAI rigidity library and adapts the
Slaman–Woodin methods cited in `formalization.yaml`. It is not an invocation of
automorphism rigidity for a map of a different type. No claim of independent
novelty assessment or expert peer review is made.

## Reproduce the checks

The repository pins Lean and the full Mathlib dependency closure. With elan,
Python 3.11 or newer, PyYAML 6.0.2, and bubblewrap available:

```sh
python3 scripts/check-palomar.py
lake exe cache get
lake build Challenge Solution
lake env lean scripts/CheckConeRigidity.lean
lake env lean scripts/CheckConeOracleProgram.lean
lake env lean scripts/CheckConeMain.lean
bash scripts/verify-comparator.sh
```

The Comparator script uses the tools bundled with the pinned Lean release,
including the independent NanoDa and con-ron kernels. The submitted
`comparator.json` contains no user-specified external-kernel command. The script
creates a temporary verification configuration and deletes it on exit.

A successful old-toolchain build is not evidence that a new snapshot passes.
Consult the **Palomar readiness** workflow for the exact commit being proposed.
The local metadata/source checks are preflight checks, not a replacement for
Palomar's own verification and editorial review.

## Scope, foundations and review

This submission selects only cone rigidity. The repository also retains its
original truth-table-degree work, which is not selected by this configuration.
The transitive dependencies of the selected proof must use only `propext`,
`Classical.choice`, and `Quot.sound`; a `sorry` or `native_decide` dependency
would fail the check. The Challenge's deliberate proof hole is not a Solution
assumption.

The theorem is established in Lean's foundations. An axiom-dependency report
is not an extraction of a syntactic ZFC or ZF proof, and we make no separate
claim that such an extraction has been completed. The human/AI workflow and
absence of independent human review are disclosed in `formalization.yaml`.

All regular Lean files, including scripts and unrelated retained sources, were
ported to Lean's module system to meet the repository-wide requirement. The
port uses public imports and exposed public sections; compatibility options
preserve legacy private references and proof elaboration. These are elaborator
options, not added axioms. The migration script records the mechanical recipe.
The root Apache-2.0 license matches the upstream OAI license; see `NOTICE` for
attribution and the distinction between retained and added source.

## Submit only a final, reviewed snapshot

After reviewing and merging this preparation PR, use the full 40-character SHA
of the exact public commit to be submitted:

```sh
git rev-parse HEAD
```

Use https://submit.palomar-registry.org/ and select `bjoernkjoshanssen/tt-auto`.
The project is at the repository root, so the optional project/config/metadata
paths can be left at their conventional defaults: `comparator.json` and
`formalization.yaml`. The responsible maintainer can declare their relationship
to the substantive formalization on that form.

Creating or merging these files does not submit or register the result. The
maintainer must authorize submission and, after seeing the review, registration.
An automated agent should use Palomar's documented agent protocol rather than
drive the human form. No registry submission, tag challenge, public gist, or
registration is created by this PR.

Requirements consulted: https://palomar-registry.org/how-to-submit and the
linked PalomarPolicy submission standard. Policies may change; recheck the
current minimum toolchain before a later submission.
