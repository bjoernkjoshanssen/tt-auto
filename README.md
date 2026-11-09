# Turing cone rigidity and truth-table degree automorphisms

This repository contains the cone-rigidity formalization and the earlier
truth-table-degree work. The Palomar submission in the repository root is
specifically about **Turing cone rigidity**.

## The compared theorem

For every nonzero Turing degree `a`, the principal upper cone above `a` is not
order-isomorphic to the full partially ordered set of Turing degrees:

```lean
OAI.TuringRigidity.ConeMain.no_nontrivial_cone_iso
    (a : Degree) (ha : a ≠ ⊥) :
    ¬ Nonempty (Degree ≃o Set.Ici a)
```

These are the ordinary Turing degrees of subsets of the natural numbers.
Reducibility is Mathlib's `TuringReducible` on total characteristic functions;
`Degree` is its antisymmetrization, and bottom is the empty-set degree. The
statement has no measurability, continuity, determinacy, or persistence
hypothesis on the isomorphism.

`Challenge.lean` states this result independently, importing only Mathlib and
spelling out the elementary definitions. Its final `sorry` is deliberate and
belongs only to the statement surface. `Solution.lean` publicly imports the
existing proved declaration from `RequestProject/TuringConeMain.lean`, without
importing Challenge. `comparator.json` compares that exact fully qualified
name. A successful build alone is not a substitute for this comparison.

The proof adapts the existing OpenAI degree-rigidity machinery: a hypothetical
cone isomorphism `e` yields an inverse-join map `g(x) = e⁻¹(a ⊔ x)`; coding,
persistence, forcing, and uniform program selection produce a generic inverse
representative; the Baire-category argument then forces `a = ⊥`.

## Build and verify

The toolchain and Mathlib revision are pinned in `lean-toolchain`,
`lakefile.toml`, and `lake-manifest.json`. The default targets are Challenge and
Solution. The historical libraries remain available as explicit Lake targets.

```sh
lake exe cache get
lake build Challenge Solution
python3 scripts/check-palomar.py
python3 scripts/check-formalization.py
lake env lean scripts/CheckPalomar.lean
bash scripts/verify-comparator.sh
```

The metadata checker needs PyYAML and jsonschema. The Comparator script needs
Linux with bubblewrap (`bwrap`) and working unprivileged user namespaces; it
uses `lake comparator` and the independent NanoDa and con-ron kernels bundled
with the pinned Lean toolchain. The GitHub workflow installs these prerequisites
and repeats the checks with a read-only repository token.

The original detailed audit scripts are retained:

```sh
lake env lean scripts/CheckConeRigidity.lean
lake env lean scripts/CheckConeOracleProgram.lean
lake env lean scripts/CheckConeMain.lean
```

The target theorem's transitive axiom dependencies must be only `propext`,
`Classical.choice`, and `Quot.sound`. Deliberate Challenge holes are not part
of the Solution environment. No custom mathematical axiom is permitted.

## Palomar submission

Read the current requirements at <https://palomar-registry.org/how-to-submit>.
After all checks pass, select a pushed immutable snapshot:

```sh
git rev-parse HEAD
```

Submit `bjoernkjoshanssen/tt-auto` and that **full 40-character commit SHA** at
<https://submit.palomar-registry.org/>. This is the standard root layout, so
project path, Comparator path, and metadata path may be left at their defaults
(`comparator.json` and `formalization.yaml`). The maintainer must complete the
repository-authorization and registration decisions. Preparing or merging this
PR does not submit or register the result automatically.

`formalization.yaml` records provenance, scope, classification, AI use, review,
and limitations. This repository is the substantive development, not a wrapper
around a separately pinned repository. No Palomar acceptance or independent
human peer review is claimed by these files.

## Attribution and limitations

The cone development was produced with **ChatGPT 6 Pro** under Bjørn
Kjos-Hanssen's mathematical direction. It extensively reuses OpenAI's
`DegreeRigidity` development under `OAI/` and mathematical methods from
Theodore A. Slaman and W. Hugh Woodin, *Definability in Degree Structures*
(2005 manuscript, <https://math.berkeley.edu/~slaman/talks/sw.pdf>).
Precise inherited local snapshots are recorded in `formalization.yaml`.

The Palomar port follows Lean's documented module-system migration: `module`
headers, public imports, and exposed public declarations. The temporary
`backward.privateInPublic` and `backward.proofsInPublic` compatibility options
preserve pre-module elaboration; they are not axioms or disabled kernel checks.
The one-time source transformation is retained in
`scripts/port-palomar-modules.py` for auditability; it is not part of ordinary
verification. All submitted Lean sources are subject to the source-size scan,
including unrelated historical files.

The formal result is in Lean's classical foundations. A separate formal
ZFC-only or ZF-only derivation has not been extracted. Mathematical novelty,
faithfulness of the entire inherited development, and independent expert
review are distinct from successful compilation and Comparator verification.
The advertised result is the cone theorem, not every historical claim in this
repository.

Code is licensed under Apache-2.0; see `LICENSE` and `NOTICE`. Existing upstream
attribution and licenses are retained. Credits do not imply endorsement.

### Historical Aristotle credit

The repository's original README credited earlier work as follows; this is
retained and is not an attribution of the new cone proof to Aristotle:

> This project was edited by [Aristotle](https://aristotle.harmonic.fun).

To cite that assistance, tag `@Aristotle-Harmonic` on GitHub, or use:

```text
Co-authored-by: Aristotle (Harmonic) <aristotle-harmonic@harmonic.fun>
```
