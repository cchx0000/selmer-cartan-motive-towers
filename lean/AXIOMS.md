# Axiom Audit — `#print axioms` per declaration (P0-3)

Date: 2026-10-09. Environment: Lean v4.33.1, Mathlib `0df444a360eaa60ab8c11dca51a86af692955474`
(prebuilt). Method: temporary file `~/prove2me_workspace/AuditAxioms.lean`
(not committed to the repo) importing all relevant modules, run with
`lake env lean`; outputs below are verbatim. No inference about elaboration
beyond what Lean reports.

**Coverage: 22 declarations** — 4 explicit axioms, 2 bodyless opaques,
16 solution theorems (`SelmerCartanMotiveTowers.sol_<name>`).

**Headline: no `sorryAx` appears in any declaration.** All solutions are
sorry-free; the only axioms in play are Lean's base axioms and the project's
4 explicit axioms.

## Classification key

- `sorryAx` — absent everywhere (verified).
- **Lean base axioms** — `propext`, `Classical.choice`, `Quot.sound`.
- **Project axioms** — `SelmerCartanMotiveTowers.tau_one`,
  `.depth_of_full`, `.depth_of_rec`, `.tau_one_depth_fiber`
  (from `Definitions/Def_rec_one_mot.lean`).
- **Background-package hypotheses** — the `ClassFieldBackground` /
  `MotivicBackground` / `WitnessBackground` / `FormalBackground` binders and
  their Prop fields. These are *local hypotheses*, not axioms, so they never
  appear in `#print axioms` output; they are listed here as the parameterized
  assumption category each solution is conditional on.

---

## §1 — Explicit axioms (`Def_rec_one_mot.lean`)

### `SelmerCartanMotiveTowers.tau_one`
```
'SelmerCartanMotiveTowers.tau_one' depends on axioms: [SelmerCartanMotiveTowers.tau_one]
```
Classification: project axiom (self).

### `SelmerCartanMotiveTowers.depth_of_full`
```
'SelmerCartanMotiveTowers.depth_of_full' depends on axioms: [SelmerCartanMotiveTowers.depth_of_full]
```
Classification: project axiom (self).

### `SelmerCartanMotiveTowers.depth_of_rec`
```
'SelmerCartanMotiveTowers.depth_of_rec' depends on axioms: [SelmerCartanMotiveTowers.depth_of_rec]
```
Classification: project axiom (self).

### `SelmerCartanMotiveTowers.tau_one_depth_fiber`
```
'SelmerCartanMotiveTowers.tau_one_depth_fiber' depends on axioms: [SelmerCartanMotiveTowers.depth_of_full,
 SelmerCartanMotiveTowers.depth_of_rec,
 SelmerCartanMotiveTowers.tau_one,
 SelmerCartanMotiveTowers.tau_one_depth_fiber]
```
Classification: project axioms (depends on all four; its statement mentions
the other three).

## §2 — Bodyless opaques

### `SelmerCartanMotiveTowers.full_mot` (`Def_full_mot.lean`)
```
'SelmerCartanMotiveTowers.full_mot' does not depend on any axioms
```
Classification: none (bare opaque, no body, no axiom dependencies).

### `SelmerCartanMotiveTowers.rec_one_mot` (`Def_rec_one_mot.lean`)
```
'SelmerCartanMotiveTowers.rec_one_mot' does not depend on any axioms
```
Classification: none (bare opaque, no body, no axiom dependencies).

---

## §3 — Solution theorems

### `SelmerCartanMotiveTowers.sol_thm_ray_class_primitive` (M1)
```
'SelmerCartanMotiveTowers.sol_thm_ray_class_primitive' depends on axioms: [propext, Classical.choice, Quot.sound]
```
Classification: Lean base axioms. Background hypotheses: `ClassFieldBackground`.

### `SelmerCartanMotiveTowers.sol_thm_universal_higher_obstruction_recursion` (M2)
```
'SelmerCartanMotiveTowers.sol_thm_universal_higher_obstruction_recursion' depends on axioms: [SelmerCartanMotiveTowers.tau_one]
```
Classification: project axiom `tau_one` (only). Background hypotheses:
`FormalBackground`. Note: the `tau_one` dependency is inherited through the
structure chain — `FormalBackground` imports `selmer_cartan_tower`, whose
field types (`square_comm`, pullback universal property) mention `tau_one`;
verified by `#print axioms` on `FormalBackground.stackIsDerived` and on
`selmer_cartan_tower` itself, both reporting `[tau_one]`. The proof is a pure
field projection otherwise (no `propext`/`choice` needed).

### `SelmerCartanMotiveTowers.sol_thm_formal_filtered_alignment` (M3)
```
'SelmerCartanMotiveTowers.sol_thm_formal_filtered_alignment' depends on axioms: [propext, Classical.choice, Quot.sound]
```
Classification: Lean base axioms. No background package.

### `SelmerCartanMotiveTowers.sol_thm_finite_confluent_interface` (M4)
```
'SelmerCartanMotiveTowers.sol_thm_finite_confluent_interface' depends on axioms: [propext, Classical.choice, Quot.sound]
```
Classification: Lean base axioms. No background package.

### `SelmerCartanMotiveTowers.sol_thm_motivic_seed` (M5)
```
'SelmerCartanMotiveTowers.sol_thm_motivic_seed' depends on axioms: [propext]
```
Classification: Lean base axiom `propext` only. Background hypotheses:
`MotivicBackground`.

### `SelmerCartanMotiveTowers.sol_thm_channel_complete_realization` (M6)
```
'SelmerCartanMotiveTowers.sol_thm_channel_complete_realization' depends on axioms: [propext,
 Classical.choice,
 Quot.sound]
```
Classification: Lean base axioms. No background package.

### `SelmerCartanMotiveTowers.sol_thm_role_separated_objectification` (M7)
```
'SelmerCartanMotiveTowers.sol_thm_role_separated_objectification' does not depend on any axioms
```
Classification: none (vacuous empty-model proof). No background package.

### `SelmerCartanMotiveTowers.sol_thm_finite_motivic_recursion_closure` (M8)
```
'SelmerCartanMotiveTowers.sol_thm_finite_motivic_recursion_closure' depends on axioms: [propext,
 Classical.choice,
 Quot.sound]
```
Classification: Lean base axioms. No background package.

### `SelmerCartanMotiveTowers.sol_thm_successor_stage_functor` (M9)
```
'SelmerCartanMotiveTowers.sol_thm_successor_stage_functor' does not depend on any axioms
```
Classification: none. Background hypotheses: `Obstr`, `nextObstruction`,
`mooreLift`, `hMooreClosure`.

### `SelmerCartanMotiveTowers.sol_thm_prime_power_comparison` (M10)
```
'SelmerCartanMotiveTowers.sol_thm_prime_power_comparison' depends on axioms: [propext, Classical.choice, Quot.sound]
```
Classification: Lean base axioms. Background hypotheses: `WitnessBackground`.

### `SelmerCartanMotiveTowers.sol_thm_classical_low_sector_comparison` (M11)
```
'SelmerCartanMotiveTowers.sol_thm_classical_low_sector_comparison' depends on axioms: [SelmerCartanMotiveTowers.tau_one]
```
Classification: project axiom `tau_one` (only); same structure-chain
inheritance as M2 (see note there). Background hypotheses:
`FormalBackground`.

### `SelmerCartanMotiveTowers.sol_prop_stack_globalization` (M12)
```
'SelmerCartanMotiveTowers.sol_prop_stack_globalization' depends on axioms: [SelmerCartanMotiveTowers.tau_one]
```
Classification: project axiom `tau_one` (only); same structure-chain
inheritance as M2. Background hypotheses: `FormalBackground`.

### `SelmerCartanMotiveTowers.sol_thm_marked_morita_independence` (M13)
```
'SelmerCartanMotiveTowers.sol_thm_marked_morita_independence' depends on axioms: [SelmerCartanMotiveTowers.tau_one]
```
Classification: project axiom `tau_one` (only); same structure-chain
inheritance as M2. Background hypotheses: `FormalBackground`.

### `SelmerCartanMotiveTowers.sol_thm_31adic_witness` (M14 / main goal)
```
'SelmerCartanMotiveTowers.sol_thm_31adic_witness' depends on axioms: [propext, Classical.choice, Quot.sound]
```
Classification: Lean base axioms. Background hypotheses: `WitnessBackground`.

### `SelmerCartanMotiveTowers.sol_thm_gerbe_provenance` (M15)
```
'SelmerCartanMotiveTowers.sol_thm_gerbe_provenance' depends on axioms: [propext, Classical.choice, Quot.sound]
```
Classification: Lean base axioms. Background hypotheses: `adic_witness`,
`WitnessBackground`.

### `SelmerCartanMotiveTowers.sol_thm_motivic_specialization` (M16)
```
'SelmerCartanMotiveTowers.sol_thm_motivic_specialization' depends on axioms: [propext, Classical.choice, Quot.sound]
```
Classification: Lean base axioms. Background hypotheses: `adic_witness`,
`motivic_moore_reedy`, `WitnessBackground`.

---

## Summary table

| Declaration | sorryAx | Lean base axioms | Project axioms |
|---|---|---|---|
| `tau_one` | — | — | self |
| `depth_of_full` | — | — | self |
| `depth_of_rec` | — | — | self |
| `tau_one_depth_fiber` | — | — | all four |
| `full_mot` (opaque) | — | — | — |
| `rec_one_mot` (opaque) | — | — | — |
| M1 `sol_thm_ray_class_primitive` | — | propext, choice, Quot.sound | — |
| M2 `sol_thm_universal_higher_obstruction_recursion` | — | — | `tau_one` |
| M3 `sol_thm_formal_filtered_alignment` | — | propext, choice, Quot.sound | — |
| M4 `sol_thm_finite_confluent_interface` | — | propext, choice, Quot.sound | — |
| M5 `sol_thm_motivic_seed` | — | propext | — |
| M6 `sol_thm_channel_complete_realization` | — | propext, choice, Quot.sound | — |
| M7 `sol_thm_role_separated_objectification` | — | — | — |
| M8 `sol_thm_finite_motivic_recursion_closure` | — | propext, choice, Quot.sound | — |
| M9 `sol_thm_successor_stage_functor` | — | — | — |
| M10 `sol_thm_prime_power_comparison` | — | propext, choice, Quot.sound | — |
| M11 `sol_thm_classical_low_sector_comparison` | — | — | `tau_one` |
| M12 `sol_prop_stack_globalization` | — | — | `tau_one` |
| M13 `sol_thm_marked_morita_independence` | — | — | `tau_one` |
| M14 `sol_thm_31adic_witness` (goal) | — | propext, choice, Quot.sound | — |
| M15 `sol_thm_gerbe_provenance` | — | propext, choice, Quot.sound | — |
| M16 `sol_thm_motivic_specialization` | — | propext, choice, Quot.sound | — |

**Per-solution dependency profile:**
- 9 solutions: `[propext, Classical.choice, Quot.sound]` (standard Lean base axioms only).
- 1 solution (M5): `[propext]` only.
- 2 solutions (M7, M9): no axioms at all.
- 4 solutions (M2, M11, M12, M13 — exactly the `FormalBackground` ones):
  `[SelmerCartanMotiveTowers.tau_one]` only, inherited via the
  `FormalBackground` → `selmer_cartan_tower` → `tau_one` structure chain
  (field types mention `tau_one`); their proofs are otherwise pure projections.
- 0 solutions depend on `sorryAx`.
