# Lean Formalization — Selmer–Cartan and Motivic Moore–Reedy Towers

Local Lean 4 (v4.33.1) + Mathlib formalization of the paper
`selmer_cartan_motive_towers_31adic_witness_unified_v0_1.tex`.

**Status (2026-10-09): all 16 milestone statements (M1–M16; the main goal,
Theorem 37.1, is M14) discharge sorry-free as conditionals on the
Strategy A background packages.** "Proved" here means the conditional
statement holds given the background hypotheses — see Fidelity notes
below for the coverage caveats (genuine proofs vs. background assemblies).

## Layout

- `Definitions/` — 22 definition modules:
  - 8 foundational: `finite_ordered_support`, `typed_coordinates`, `source_package`,
    `full_mot`, `rec_one_mot`, `motivic_moore_reedy`, `selmer_cartan_tower`, `adic_witness`
  - 4 arithmetic background packages (Strategy A, explicitly labeled hypotheses):
    `classfield_background`, `motivic_background`, `witness_background`, `formal_background`
  - 6 P1-3/P1-4 concrete-structure modules: `channel_index`, `moore_cohomology_line`,
    `pointed_cyclic_carrier`, `dga_obstruction`, `crt_product`, `classical_shadow_cone`
  - 3 P1-2 deep-structure modules: `confluent_package`, `role_separation`, `jet_ledger`
  - 1 P1-4 gerbe-provenance module: `gerbe_provenance` (classifying map, pullback
    identity, unipotent extension with a local `ZMod 31` model)
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
  identity, giving the Bianchi-cocycle rearrangement, the curvature expansion,
  and curvature naturality (the "gauge" clause is the gauge-action definition
  itself, `rfl`; PD filtration and filler torsor remain uncovered).
- M5 (Thm 12.2) has a real cohomology layer (`addOrderOf [b] = N` excludes
  the boundary model). The old `N • b = 0` / `d c = 0` forcing and the
  `N² • b_mot = 0` tension are repaired (2026-10-10: `isGenuine` no longer
  applies `classOf` to the non-closed antecedent). Remaining limitations:
  no faithful integral complex / cohomology interface, and the geometric
  antecedent is still satisfiable by a trivial `Unit` model.
- M11 (Thm 27.5) has a concrete target-side `ClassicalMooreCone` with proved
  reduction laws; the source category stays as background.
- M16 (Thm 38.5) constructs real pointed isomorphisms between three concrete
  order-31 carriers (carrier-level only).
- M9/M12/M13 have no Mathlib foundation (derived AG, motivic homotopy,
  derived Morita); see `P1_INFEASIBLE.md`. They remain as explicitly labeled
  background assumptions.
- M15 (Thm 38.1) now carries the `GerbeProvenance` structure plus a local
  `ZMod 31` model of the unipotent extension as satisfiability evidence for
  the repaired P0-0 fields (P0-0 fix, 2026-10-10). The model only covers the
  `UnipotentExtension` layer: real group/homomorphism structure, two-sided
  kernel identification (only kernel ⊆ `ZMod 31`-multiples is stated), band
  action laws, a real pullback operation, and the arithmetic realization
  remain background; the bare `provenanceFor` predicate is still projected
  in the production conclusion.
- The rest are direct assemblies of background-package fields — true and
  provable, but literally weaker than the paper's intent. This is the known
  trade-off of the axiomatic skeleton; see `BACKGROUND_INPUTS.md` for the
  per-field ledger and `P1_INFEASIBLE.md` for the hard boundary.

## Not yet done

- Platform `/verify` on Prove2Me: deliberately deferred (local-only for now).
- Concrete arithmetic inputs (Strategy B) to replace background axioms later.
- Paper 1 (`arithmetic-cartan-single-prime-atlas`) is on hold pending the
  author's revision.
