# Lean Formalization — Selmer–Cartan and Motivic Moore–Reedy Towers

Local Lean 4 (v4.33.1) + Mathlib formalization of the paper
`selmer_cartan_motive_towers_31adic_witness_unified_v0_1.tex`.

**Status (2026-10-09): all 16 milestones (M1–M16; the main goal,
Theorem 37.1, is M14) proved, sorry-free, as conditionals on the
Strategy A background packages.**

## Layout

- `Definitions/` — 21 definition modules:
  - 8 foundational: `finite_ordered_support`, `typed_coordinates`, `source_package`,
    `full_mot`, `rec_one_mot`, `motivic_moore_reedy`, `selmer_cartan_tower`, `adic_witness`
  - 4 arithmetic background packages (Strategy A, explicitly labeled hypotheses):
    `classfield_background`, `motivic_background`, `witness_background`, `formal_background`
  - 6 P1-3/P1-4 concrete-structure modules: `channel_index`, `moore_cohomology_line`,
    `pointed_cyclic_carrier`, `dga_obstruction`, `crt_product`, `classical_shadow_cone`
  - 3 P1-2 deep-structure modules: `confluent_package`, `role_separation`, `jet_ledger`
- `Theorems/` — 16 production theorem statements (`Thm_SelmerCartanMotiveTowers_*.lean`).
  Each now imports its `Solutions/` module and discharges the statement by
  applying the corresponding `sol_*` proof (P1-5 rewiring complete; no `by sorry` remains).
- `Solutions/` — 16 sorry-free substantive proof modules (`Sol_*.lean`),
  one per milestone (M1–M16, goal included), plus `SmokeTest.lean`
  (smoke test only, not a paper milestone). Each `theorem sol_* ...`
  has binders/conclusion identical to its production statement.

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
  (Massey cocycle assembly; concrete Moore line ↔ confluence line via CRT,
  with q-primary reduction compatibility).
- M2 (Thm 9.4) now defines a `SuperDGA` from scratch and proves the Bianchi
  identity, deriving cocycle/lifting/naturality (PD filtration and filler
  torsor remain uncovered).
- M5 (Thm 12.2) has a real cohomology layer (`addOrderOf [b] = N` excludes
  the boundary model); the integral `d c = N b` vs `d² = 0` tension and the
  geometric antecedent are documented limitations.
- M11 (Thm 27.5) has a concrete target-side `ClassicalMooreCone` with proved
  reduction laws; the source category stays as background.
- M16 (Thm 38.5) constructs real pointed isomorphisms between three concrete
  order-31 carriers (carrier-level only).
- M9/M12/M13/M15 have no Mathlib foundation (derived AG, motivic homotopy,
  derived Morita); see `P1_INFEASIBLE.md`. They remain as explicitly labeled
  background assumptions.
- The rest are direct assemblies of background-package fields — true and
  provable, but literally weaker than the paper's intent. This is the known
  trade-off of the axiomatic skeleton; see `BACKGROUND_INPUTS.md` for the
  per-field ledger and `P1_INFEASIBLE.md` for the hard boundary.

## Not yet done

- Platform `/verify` on Prove2Me: deliberately deferred (local-only for now).
- Concrete arithmetic inputs (Strategy B) to replace background axioms later.
- Reconnect `Solutions/` proofs to the `Theorems/` draft statements and
  keep per-declaration `#print axioms` reports (external-verifier P0-3/P1-5).
- Paper 1 (`arithmetic-cartan-single-prime-atlas`) is on hold pending the
  author's revision.
