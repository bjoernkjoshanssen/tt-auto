# Truth-table degrees and Turing cone rigidity

This repository contains the original truth-table-degree development and the
cone-rigidity proof built on the OpenAI Turing-degree rigidity library. The
Palomar submission at the repository root concerns **Turing cone rigidity**.

## The compared result

```lean
import RequestProject.TuringConeMain

#check OAI.TuringRigidity.ConeMain.no_nontrivial_cone_iso
```

For every nonzero Turing degree `a`, its principal upper cone is not
order-isomorphic to the full order of Turing degrees. There is no measurability,
continuity, determinacy, persistence, or model-existence premise. These are
ordinary degrees of subsets of the natural numbers, not merely computably
enumerable degrees. The [mathematical account](PALOMAR.md) explains the statement,
proof architecture, sources, and limitations.

[Challenge.lean](Challenge.lean) imports only Mathlib and defines the ordinary
degree quotient, order, concrete join, and computable bottom independently.
Only its final theorem proof is deliberately omitted. [Solution.lean](Solution.lean)
exports the existing proof and does not import Challenge.
[comparator.json](comparator.json) selects exactly
`OAI.TuringRigidity.ConeMain.no_nontrivial_cone_iso`.

## Build and verify

Lean and every Git dependency are pinned. The default build targets are
Challenge and Solution:

```sh
lake exe cache get
lake build Challenge Solution
python3 scripts/check-palomar.py
python3 scripts/check-formalization.py
lake env lean scripts/CheckPalomar.lean
bash scripts/verify-comparator.sh
```

The metadata checker needs PyYAML and jsonschema. Comparator requires Linux,
bubblewrap (`bwrap`), and working unprivileged user namespaces; it uses the
pinned toolchain's `leanchecker`, NanoDa, and con-ron. It compares the independent
statement and then checks the exported proof. A normal build alone is not a
replacement for Comparator.

The read-only **Cone rigidity and Palomar verification** workflow checks all
tracked sources and metadata, builds the selected result, runs the transitive
axiom audits, and runs Comparator. It also retains the three earlier audit
scripts: `CheckConeRigidity.lean`, `CheckConeOracleProgram.lean`, and
`CheckConeMain.lean`. Only `propext`, `Classical.choice`, and `Quot.sound` are
permitted for the selected proof. The intentional Challenge placeholder is
never part of Solution's environment.

## Submit an immutable snapshot

Review the current rules at <https://palomar-registry.org/how-to-submit>.
After the checks pass for a pushed commit, obtain its full immutable identifier:

```sh
git rev-parse HEAD
```

At <https://submit.palomar-registry.org/>, select `bjoernkjoshanssen/tt-auto` and
that **full 40-character SHA**. This is the standard root layout: the project
path and Comparator/metadata paths can use the defaults (`comparator.json` and
`formalization.yaml`). The maintainer must complete repository authorization
and the registry's submission/review steps. Preparing or merging the PR does
not register or publish the result automatically.

[formalization.yaml](formalization.yaml) records substantive-development status,
mathematical origin, precise upstream revisions, AI use, classification, review,
and scope. No Palomar acceptance or independent human peer review is claimed.

## Attribution and scope

The cone-specific development was produced with **ChatGPT 6 Pro** under
Bjørn Kjos-Hanssen's mathematical direction. It extensively reuses OpenAI's
DegreeRigidity formalization and methods from Theodore A. Slaman and W. Hugh
Woodin's *Definability in Degree Structures* (2005 manuscript). Exact inherited
provenance and module/codec-port repairs are documented in
[OAI/PORTING.md](OAI/PORTING.md), the metadata, and [NOTICE](NOTICE).

The proof is in classical Lean foundations. A separate formal derivation in
ZFC or ZF has not been extracted. Independent expert review and historical
priority are different questions from successful kernel verification. The
advertised result is the cone theorem, not all historical claims in the repo.

The code is licensed under Apache-2.0; see [LICENSE](LICENSE). External
mathematical papers and dependencies retain their own licenses. Credits do
not imply endorsement.

### Inherited Aristotle credit

The original README attribution is retained for the earlier work, not as an
attribution of the new cone proof to Aristotle:

> This project was edited by [Aristotle](https://aristotle.harmonic.fun).

Its suggested co-author credit was:

```text
Co-authored-by: Aristotle (Harmonic) <aristotle-harmonic@harmonic.fun>
```
