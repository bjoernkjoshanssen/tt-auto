# Truth-table degrees and Turing cone rigidity

This repository contains the original truth-table-degree development together
with the cone-rigidity development built on the OAI Turing-rigidity library.

## Turing cone rigidity

```lean
import RequestProject.TuringConeMain

#check OAI.TuringRigidity.ConeMain.no_nontrivial_cone_iso
```

For every nonzero Turing degree `a`, the principal upper cone above `a` is not
order-isomorphic to the entire order of Turing degrees. See
[PALOMAR.md](PALOMAR.md) for the mathematical account, exact scope, provenance,
AI disclosure, verification commands and submission instructions.

The Palomar preparation uses independent [Challenge](Challenge.lean) and
[Solution](Solution.lean) modules, [comparator.json](comparator.json), and
[formalization.yaml](formalization.yaml). The theorem selected for comparison is
exactly `OAI.TuringRigidity.ConeMain.no_nontrivial_cone_iso`. Preparation does
not imply Palomar review or registration. Submissions go to
https://submit.palomar-registry.org/.

AI-assisted cone development: **ChatGPT 6 Pro**, with mathematical direction
and repository maintenance by Bjørn Kjos-Hanssen. Upstream OAI, Lean and
Mathlib contributions are credited separately in the metadata and NOTICE.
No independent human peer review is asserted.

## Build

```sh
lake exe cache get
lake build
```

The toolchain and all Git dependencies are pinned. The `Palomar readiness`
workflow checks the submission files, builds the selected result, runs the
axiom audits, and compares the independent statement against the proof using
the pinned toolchain's Comparator and independent kernels.

## Inherited project attribution

The original README supplied the following attribution, retained here rather
than attributing earlier work to the cone-rigidity agent:

This project was edited by [Aristotle](https://aristotle.harmonic.fun).

To cite Aristotle:
- Tag @Aristotle-Harmonic on GitHub PRs/issues
- Add as co-author to commits:

```text
Co-authored-by: Aristotle (Harmonic) <aristotle-harmonic@harmonic.fun>
```
