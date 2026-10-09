# Lean Formalization — Selmer–Cartan and Motivic Moore–Reedy Towers

Local Lean 4 (v4.33.1) + Mathlib formalization of the paper
`selmer_cartan_motive_towers_31adic_witness_unified_v0_1.tex`.

**Status (2026-10-09): all 16 milestones (M1–M16; the main goal,
Theorem 37.1, is M14) proved, sorry-free, as conditionals on the
Strategy A background packages.**

## Layout

- `Definitions/` — 12 definitions:
  - 8 foundational: `finite_ordered_support`, `typed_coordinates`, `source_package`,
    `full_mot`, `rec_one_mot`, `motivic_moore_reedy`, `selmer_cartan_tower`, `adic_witness`
  - 4 arithmetic background packages (Strategy A, explicitly labeled hypotheses):
    `classfield_background`, `motivic_background`, `witness_background`, `formal_background`
- `Theorems/` — 16 theorem drafts (`Thm_SelmerCartanMotiveTowers_*.lean`).
  Each is a `theorem ... := by sorry` placeholder whose statement is the
  verified formal statement; the real proofs live in `Solutions/`.
- `Solutions/` — 16 sorry-free substantive proof modules (`Sol_*.lean`),
  one per milestone (M1–M16, goal included), plus `SmokeTest.lean`
  (smoke test only, not a paper milestone). Each `theorem sol_* ...`
  has binders/conclusion identical to its draft; all modules build cleanly
  under `lake build` (0 `sorry`, verified by grep). Note: `Solutions/`
  modules do not import `Theorems/`, so the `by sorry` drafts are not yet
  discharged by these proofs — see "Not yet done".

## Method: Strategy A (axiomatic skeleton)

Deep arithmetic inputs (Kummer theory, ray class fields, Chebotarev, Tate
duality, global reciprocity, motivic six-functor inputs, 31-adic numerics)
are introduced as explicitly-labeled background hypotheses, not proved.
Milestones are proved as conditionals: *given the arithmetic background
package, the paper's construction goes through.*

During the work, 10 first-draft statements were found FALSE (machine-checked
countermodels) and revised into conditionals; each revision is documented in
the file's `REVISION NOTE`. One instance-shadowing bug was fixed
(`MotivicBackground`: redundant `[AddCommGroup bg.Cochain]` binder removed,
package instance registered instead).

## Fidelity notes

- M1 (Thm 6.5) and M3 (Thm 8.21) are genuine Mathlib proofs
  (Massey cocycle assembly; canonical pointed isomorphism of cyclic groups).
- The rest are direct assemblies of background-package fields — true and
  provable, but literally weaker than the paper's intent. This is the known
  trade-off of the axiomatic skeleton.
- M7 (Thm 19.9) is proved by the vacuous empty model; its statement only
  requires the existential shape. Strengthening it (e.g. `0 < n`) requires a
  statement revision, not a proof fix.

## Not yet done

- Platform `/verify` on Prove2Me: deliberately deferred (local-only for now).
- Concrete arithmetic inputs (Strategy B) to replace background axioms later.
- Reconnect `Solutions/` proofs to the `Theorems/` draft statements and
  keep per-declaration `#print axioms` reports (external-verifier P0-3/P1-5).
- Paper 1 (`arithmetic-cartan-single-prime-atlas`) is on hold pending the
  author's revision.
