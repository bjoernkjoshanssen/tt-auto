# Pairwise rigidity of principal Turing cones

The current Palomar package at the repository root concerns **pairwise rigidity
of principal upper cones of ordinary Turing degrees**. It is a substantive
strengthening proposed as the next version of **PALOMAR-2026-11-09-000019**,
not as a separate registration. Version 1 and its archived source remain
unchanged. The repository also retains the earlier cone-versus-whole theorem
and historical truth-table work.

## The compared results

```lean
import RequestProject.TuringTwoConeMain

#check OAI.TuringRigidity.TwoConeMain.cones_orderIso_iff
#check OAI.TuringRigidity.TwoConeMain.cone_iso_apply_val
```

The first theorem states

```lean
Nonempty (Set.Ici a ≃o Set.Ici b) ↔ a = b
```

for all Turing degrees `a,b`. The second states that every such isomorphism
fixes every underlying degree: `(e x).val = x.val`. In particular, each cone
has only the identity automorphism. Both statements concern arbitrary order
isomorphisms, without measurability, continuity, determinacy, persistence, or
model-existence hypotheses. These are unrestricted degrees of subsets of the
natural numbers, not just computably enumerable degrees.

[Challenge.lean](Challenge.lean) imports only Mathlib. It independently defines
the ordinary degree quotient and its order, with concrete join and bottom
instances, then states both results. Only the two final theorem proofs are
intentionally omitted. [Solution.lean](Solution.lean) exports the unchanged
proofs from `RequestProject/TuringTwoConeMain.lean` and never imports Challenge.
[comparator.json](comparator.json) selects both statements separately.

The [submission account](PALOMAR.md) describes the mathematical meaning,
proof architecture, provenance, and limitations. The [development account](TWO_CONE_RIGIDITY.md)
describes the two-cone proof in more detail.

## Build and verify

Lean and every Git dependency remain pinned. Default build targets are
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
bubblewrap (`bwrap`), and working unprivileged user namespaces. It uses the
pinned toolchain's `leanchecker`, NanoDa, and con-ron to compare the independent
statements and verify the exported proofs. A build alone is not Comparator.

The **Cone rigidity and Palomar verification** workflow now compares the TWO
new selected results. It also retains the old cone-proof axiom audits as
regression checks. The separate **Two-cone rigidity development** workflow
builds the completed two-cone endpoint and runs its seven audit scripts,
including exact unconditional types with `autoImplicit false`. Only `propext`,
`Classical.choice`, and `Quot.sound` are permitted in the proved results.
Challenge's deliberate proof holes never enter Solution's environment.

## Submit the strengthened version of the existing Palomar entry

Review the current rules at <https://palomar-registry.org/how-to-submit>.
After the checks pass for a pushed commit, copy its full immutable identifier:

```sh
git rev-parse HEAD
```

At <https://submit.palomar-registry.org/>, select `bjoernkjoshanssen/tt-auto`
and that **full 40-character SHA**. The normal root layout uses default paths:
`comparator.json` and `formalization.yaml`, with no project subdirectory.
Use **PALOMAR-2026-11-09-000019** as the existing registration identifier, or
accept Palomar's automatic match for this repository and Comparator path.
Both compared theorems belong to the proposed next version of that record.
Do not change the Comparator path to obtain a different registration identity.

This is an ordinary source-version submission with stronger mathematical
content, not an administrative metadata correction of version 1. Earlier
wording describing this package as a separate new entry was mistaken for
this submission identity and has been corrected.

The maintainer must complete authorization, verification, review, and the
explicit registration decision. Updating these files does not modify an
already submitted immutable snapshot or register a version automatically.
Submit the corrected full SHA for a fresh review. Keep the private status-page
link Palomar provides; do not commit it to this public repository.

## Earlier registered statement and version history

**PALOMAR-2026-11-09-000019 v1** states that no proper principal upper cone is
order-isomorphic to the whole Turing-degree structure. Its root Challenge,
metadata, and proof remain accessible at the previous package snapshot:

<https://github.com/bjoernkjoshanssen/tt-auto/tree/0d8119a280fa466a6b4ed35f0940a8a526c751d9>.

The proposed next version strengthens that statement to pairwise
non-isomorphism of cones with unequal bases and pointwise identity of every
cone isomorphism. The old theorem follows by taking the source cone above
the computable degree. It remains valid and is not being corrected or retracted.

Palomar reviews a fixed commit, not the moving `main` branch. A new registered
version does not rewrite version 1 or its archived source; cite the version
number when referring to the earlier result. The old proved theorem is also
retained in the current source tree as
`OAI.TuringRigidity.ConeMain.no_nontrivial_cone_iso`.

## Attribution and scope

The cone and two-cone developments were produced with **ChatGPT 6 Pro** under
Bjørn Kjos-Hanssen's mathematical direction. They extensively reuse OpenAI's
DegreeRigidity formalization and methods from Theodore A. Slaman and W. Hugh
Woodin's *Definability in Degree Structures* (2005 manuscript). Exact inherited
provenance and module/codec-port repairs are documented in
[OAI/PORTING.md](OAI/PORTING.md), [formalization.yaml](formalization.yaml), and
[NOTICE](NOTICE). This packaging changes no mathematical proof or toolchain.

The proof is in classical Lean foundations; a separate formal derivation in
ZFC or ZF has not been extracted. Independent human review and historical
priority remain distinct questions from successful kernel verification.
No source-author endorsement or registration of the proposed next version is
asserted. The code is Apache-2.0; see [LICENSE](LICENSE). External sources and
dependencies retain their own licenses. Credits do not imply endorsement.

### Inherited Aristotle credit

The original attribution is retained for earlier work, not for the new cone
proofs:

> This project was edited by [Aristotle](https://aristotle.harmonic.fun).

Its suggested co-author credit was:

```text
Co-authored-by: Aristotle (Harmonic) <aristotle-harmonic@harmonic.fun>
```
