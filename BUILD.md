# Reproducible build (external-verifier todo.md P0-3)

## What this fixes

The pushed commit `ebf86316` contained no `lean-toolchain`, no
`lakefile.lean`/`lakefile.toml`, and no dependency lock file, so the claim
"local `lake build` OK" could not be reproduced from a clean checkout.
This commit adds `lean-toolchain` and `lakefile.lean` at the repo root plus
the recorded versions below, closing that gap.

## Exact versions (from the machine that completed Strategy A)

- Lean: `leanprover/lean4:v4.33.1` (`lean-toolchain`)
- Mathlib: `0df444a360eaa60ab8c11dca51a86af692955474`
  (pinned in `lakefile.lean`; matches `lake-manifest.json` of the build machine)
- Layout: repo root is the Lake package; Lean sources live under `lean/`
  (`Definitions/`, `Theorems/`, `Solutions/`).

## Procedure (clean checkout)

```sh
git clone https://github.com/cchx0000/selmer-cartan-motive-towers.git
cd selmer-cartan-motive-towers
# elan must be installed; then:
lake update        # fetches pinned Mathlib; on throttled networks use a
                   # local git mirror for github.com (see repo docs)
lake build 2>&1 | tee build.log
```

Record as build credentials: repo commit SHA (`git rev-parse HEAD`), the two
version strings above, the full `build.log`, and the exit code.

## Solution naming (decision recorded 2026-10-09)

The 16 substantive `Solutions/` modules now declare uniquely-named theorems
`SelmerCartanMotiveTowers.sol_<name>` (one per milestone, M1–M16, e.g.
`sol_thm_ray_class_primitive`), so they can be jointly imported without
collision. `Solutions/` modules still do not import `Theorems/` (independent
per-module evaluation, the current Prove2Me mode); the reverse direction is
done — each `Theorems/` module now imports its `Solutions/` module and
discharges the statement by applying `sol_*` (verifier item P1-5 complete;
no `by sorry` remains in production statements).

## Axiom audit (verifier P0-3 acceptance)

For each production declaration, a `#print axioms` (or equivalent) report is
kept, distinguishing: `sorryAx`, Lean base axioms, explicitly allowed
project axioms, and parameterized background hypotheses. In particular:

- `Def_rec_one_mot.lean` carries 4 explicit `axiom`s
  (`tau_one`, `depth_of_full`, `depth_of_rec`, `tau_one_depth_fiber`);
  `Def_full_mot.lean` / `Def_rec_one_mot.lean` carry opaque defs with no
  body — their transitive axiom sets are audited separately.
- Text grep for `sorry`/`admit`/`axiom`/`unsafe` is **not** a substitute
  for this per-declaration audit.

See `lean/AXIOMS.md` for the per-declaration reports.
