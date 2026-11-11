# Mathematical account: pairwise rigidity of principal Turing cones

## Two precisely compared statements

A real here is a subset of the natural numbers represented by a Boolean
characteristic function. Ordinary Turing reducibility means computability by
an oracle machine; mutual reducibility defines a degree. The partial order of
these degrees is the ordinary Turing-degree structure, with all set degrees,
not just computably enumerable degrees.

For a degree `a`, write `C_a = Set.Ici a`, the principal UPPER cone of all
degrees greater than or equal to `a`, including its least element `a`.
The headline theorem is:

```lean
OAI.TuringRigidity.TwoConeMain.cones_orderIso_iff (a b : Degree) :
    Nonempty (Set.Ici a ≃o Set.Ici b) ↔ a = b
```

Thus no two distinct bases give isomorphic cones, including incomparable
bases. The isomorphism is an arbitrary bijection preserving and reflecting
order. No preservation of the jump or additional definability is stipulated.

The second independently compared theorem is:

```lean
OAI.TuringRigidity.TwoConeMain.cone_iso_apply_val {a b : Degree}
    (e : Set.Ici a ≃o Set.Ici b) (x : Set.Ici a) :
    (e x).val = x.val
```

It asserts pointwise identity on the underlying degrees. Specializing `b=a`
gives rigidity of every individual cone. This is stronger information than
the first theorem alone: equality of the bases by itself does not rule out a
nonidentity automorphism. The repository also proves `cone_automorphism_eq_refl`
and `cone_iso_unique`; those corollaries are audited by the development
workflow, while the two displayed statements are the selected Comparator
surface for this submission.

Neither compared theorem retains a Borel, continuity, determinacy, persistence,
or model-existence assumption. Their scope does not include lower cones,
arbitrary filters, or other reducibility structures.

## Independent and concrete Challenge

`Challenge.lean` imports only Mathlib, not this repository's proof development
or a prior registered Challenge. It independently gives Boolean oracles,
Mathlib `TuringReducible`, the quotient by mutual reducibility, and the usual
quotient order. The interleaving join and empty-set bottom instances are
included to match the Solution's concrete order instance, not to add axioms.
All supporting claims are proved; only the two advertised Challenge proofs
are deliberate placeholders.

`Solution.lean` publicly imports the unchanged completed two-cone proof.
It does not import Challenge. Comparator compares the separate environments,
the two statement types, their ordinary definitions, and the actual proof
objects with only the standard allowed axioms. The small statement surface
is intentionally separate from the substantial model and forcing machinery.

## Proof architecture

Suppose `e : C_a ≃o C_b`. Define on ALL ordinary degrees

```
h(x) = e(a join x),       g(x) = e^{-1}(b join x).
```

The decisive representation theorem supplies a fixed real R of degree e(a')
and a finite oracle program p. On every input X arithmetic-generic relative
to R^(5), the program with oracle X join R^(5) is total and has output degree
g(degree X). This is a nonconstructive existence-and-correctness theorem, not
an algorithm taking an uncountable abstract isomorphism as executable input.

Relative coding and decoding give two-sided fifth-jump locality bounds with
DISTINCT parameters e(a') and e^{-1}(b'). Common jump ideals containing both
are invariant in the two-cone sense. Persistent partial isomorphisms between
cone intersections have complete indexed graphs recursive in the eleventh
jump of a column presentation. The source-cone test costs no extra jump.
Arithmetic restrictions without a persistence assumption avoid circularity
in the obstruction argument that gives persistent extensions.

Finite program indices replace existential graph reals in the extension
criterion, giving a uniform Pi-1-1 coding of persistence. Its absoluteness,
internal graph reconstruction, and collapse/descent place the whole native
graph in the relevant relative L(R), without assuming Choice inside L(R).
Bounded separation constructs the joined-inverse graph. This relation need
not be injective and is not treated as an automorphism.

In a suitable Cohen extension, the partial map is chosen as a restriction
of the ORIGINAL global e. Its two locality parameters ensure coherence.
The existing relation-only compiler absorbs an extension-real definition
parameter into a larger base model while keeping the old computational
parameter R. Relative minimal pairs are taken over B join Y with degree B=b.
Ordinary lower bounds outside the source cone are handled by the equivalence

```
z <= g(x)  iff  e(a join z) <= b join x.
```

The arithmetic source equation then transfers correctness from Cohen columns
to sufficiently arithmetic-generic inputs in that extension. Models can cover
any prescribed countable sequence of inputs. There are only countably many
candidates (R,p), since R represents one fixed degree and p is finite. Choosing
one bad generic input per candidate, if every candidate failed somewhere,
contradicts the countable-test theorem. This gives one globally valid generic
program, not just a different program for each countable model.

A generic-to-Borel upgrade and four-value category recovery give
`e(a join x) <= b join x`. Applying the same argument to e^{-1} yields equality.
Substituting the bases gives a=b, and substituting a degree already above the
base gives pointwise identity. The representation hypotheses of intermediate
lemmas are thus discharged in the final compared declarations.

## Relationship to the first Palomar result

The previous result ruled out an isomorphism from the entire degree structure
to a proper principal upper cone. It follows from the new pairwise theorem by
identifying the whole structure with the cone above the computable degree.
The new pairwise statement additionally compares arbitrary nonzero bases,
and the pointwise statement proves rigidity of every cone.

This preparation is for a NEW mathematical entry, not a revision or correction
of the first entry. The earlier root Challenge, metadata, and proof are still
accessible at the immutable snapshot

<https://github.com/bjoernkjoshanssen/tt-auto/tree/0d8119a280fa466a6b4ed35f0940a8a526c751d9>.

Changing the current root Challenge cannot alter the old recorded commit.
The old proved theorem also remains in the current repository. No new
registration is performed by changing these packaging files.

## Provenance, AI usage, and review limits

The background methods are those of Theodore A. Slaman and W. Hugh Woodin,
*Definability in Degree Structures* (2005 manuscript), especially Chapters 4–5:
<https://math.berkeley.edu/~slaman/talks/sw.pdf>.
The new two-cone theorem is not claimed to be a verbatim theorem there.

The inherited formal infrastructure is OpenAI's DegreeRigidity development at
<https://github.com/openai/math/tree/fd4aeeb2ee4fc729c18d98444fed42fd0529eeeb/lean/OAI/Computability/DegreeRigidity>.
Exact inherited and port provenance is documented in `OAI/PORTING.md`.
The two-cone proof was completed in PR 4 and merged at
`3190d8d1a78e709297423d1343f68395127be5de`. This submission preparation changes
neither its proofs nor the pinned dependencies.

The cone-specific and two-cone work was generated and revised with **ChatGPT
6 Pro**, under Bjørn Kjos-Hanssen's mathematical direction. That is the
maintainer-requested attribution. OpenAI's inherited work and Mathlib are
credited separately; the earlier Aristotle credit concerns historical
truth-table work, not the cone proofs.

The `original-proof` label identifies where this argument is presented, not
an independently reviewed claim of priority. No source-author endorsement is
claimed. The proof uses classical Lean foundations and only `propext`,
`Classical.choice`, and `Quot.sound` as additional named axiom dependencies;
a separate formal ZFC or ZF derivation has not been extracted. Successful
kernel verification is distinct from independent human review of the
mathematical interpretation, inherited development, and historical claims.

Fresh Comparator verification must cover BOTH new statements at the exact
submitted commit. Prior Comparator checks of the weaker theorem are not a
substitute. Palomar's own mechanical and editorial review and the maintainer's
explicit registration decision remain separate from this preparation.
