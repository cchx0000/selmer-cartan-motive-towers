# Axiom Audit — `#print axioms` per declaration (P0-3)

Date: 2026-10-09 (refreshed after P0-1/P0-2/P1-2 statement revisions).
Environment: Lean v4.33.1, Mathlib `0df444a360eaa60ab8c11dca51a86af692955474`
(prebuilt). Method: temporary file `~/prove2me_workspace/AuditAxioms2.lean`
(not committed to the repo) importing all relevant modules, run with
`lake env lean`; outputs below are verbatim. No inference about elaboration
beyond what Lean reports.

**Coverage: 28 declarations** — 4 explicit axioms, 2 bodyless opaques,
6 package instance declarations (new in this revision), 16 solution
theorems (`SelmerCartanMotiveTowers.sol_<name>`).

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
Classification: no axioms (opaque type, no body).

### `SelmerCartanMotiveTowers.rec_one_mot` (`Def_rec_one_mot.lean`)
```
'SelmerCartanMotiveTowers.rec_one_mot' does not depend on any axioms
```
Classification: no axioms (opaque type, no body).

## §3 — Package instance declarations (new in this revision)

The P0-1/P0-2 revisions register each background package's own
`AddCommGroup` structure as an instance so that notation (`0`, `•`,
`addOrderOf`) in statements resolves to the package's own group structure
rather than an arbitrary unrelated instance. Each instance is a projection
of a structure field; Lean reports the standard base-axiom triple for
their elaboration.

### `SelmerCartanMotiveTowers.MotivicBackground.instAddCommGroup`
```
'SelmerCartanMotiveTowers.MotivicBackground.instAddCommGroup' depends on axioms: [propext, Classical.choice, Quot.sound]
```
Classification: Lean base axioms.

### `SelmerCartanMotiveTowers.MotivicBackground.instAddCommGroupCohomology` (P0-2)
```
'SelmerCartanMotiveTowers.MotivicBackground.instAddCommGroupCohomology' depends on axioms: [propext,
 Classical.choice,
 Quot.sound]
```
Classification: Lean base axioms.

### `SelmerCartanMotiveTowers.AdicWitness.instAddCommGroupTerminal` (P0-1)
```
'SelmerCartanMotiveTowers.AdicWitness.instAddCommGroupTerminal' depends on axioms: [propext,
 Classical.choice,
 Quot.sound]
```
Classification: Lean base axioms.

### `SelmerCartanMotiveTowers.AdicWitness.instAddCommGroupLocal` (P0-1)
```
'SelmerCartanMotiveTowers.AdicWitness.instAddCommGroupLocal' depends on axioms: [propext, Classical.choice, Quot.sound]
```
Classification: Lean base axioms.

### `SelmerCartanMotiveTowers.WitnessBackground.instAddCommGroupObstruction` (P0-1)
```
'SelmerCartanMotiveTowers.WitnessBackground.instAddCommGroupObstruction' depends on axioms: [propext,
 Classical.choice,
 Quot.sound]
```
Classification: Lean base axioms.

### `SelmerCartanMotiveTowers.WitnessBackground.instAddCommGroupLocalObstruction` (P0-1)
```
'SelmerCartanMotiveTowers.WitnessBackground.instAddCommGroupLocalObstruction' depends on axioms: [propext,
 Classical.choice,
 Quot.sound]
```
Classification: Lean base axioms.

## §4 — Solution theorems

### `SelmerCartanMotiveTowers.sol_thm_ray_class_primitive` (M1)
```
'SelmerCartanMotiveTowers.sol_thm_ray_class_primitive' depends on axioms: [propext, Classical.choice, Quot.sound]
```
Classification: Lean base axioms. Background hypotheses: `ClassFieldBackground`.

### `SelmerCartanMotiveTowers.sol_thm_universal_higher_obstruction_recursion` (M2)
```
'SelmerCartanMotiveTowers.sol_thm_universal_higher_obstruction_recursion' depends on axioms: [SelmerCartanMotiveTowers.tau_one]
```
Classification: project axiom `tau_one`, inherited via the
`FormalBackground` → `selmer_cartan_tower` → `tau_one` structure-field type
chain (verified separately on `FormalBackground.stackIsDerived` and
`selmer_cartan_tower`). The proof itself is a pure projection.
Background hypotheses: `FormalBackground`.

### `SelmerCartanMotiveTowers.sol_thm_formal_filtered_alignment` (M3)
```
'SelmerCartanMotiveTowers.sol_thm_formal_filtered_alignment' depends on axioms: [propext, Classical.choice, Quot.sound]
```
Classification: Lean base axioms.

### `SelmerCartanMotiveTowers.sol_thm_finite_confluent_interface` (M4)
```
'SelmerCartanMotiveTowers.sol_thm_finite_confluent_interface' depends on axioms: [propext, Classical.choice, Quot.sound]
```
Classification: Lean base axioms.

### `SelmerCartanMotiveTowers.sol_thm_motivic_seed` (M5)
```
'SelmerCartanMotiveTowers.sol_thm_motivic_seed' depends on axioms: [propext, Classical.choice, Quot.sound]
```
Classification: Lean base axioms. Background hypotheses: `MotivicBackground`.
**Change from previous audit:** was `[propext]` only; now the full triple —
the P0-2 revision added the cohomology layer (`Cohomology`, `classOf`,
`hb_class_order`), whose instance projections elaborate with the standard
base axioms.

### `SelmerCartanMotiveTowers.sol_thm_channel_complete_realization` (M6)
```
'SelmerCartanMotiveTowers.sol_thm_channel_complete_realization' depends on axioms: [propext,
 Classical.choice,
 Quot.sound]
```
Classification: Lean base axioms.

### `SelmerCartanMotiveTowers.sol_thm_role_separated_objectification` (M7)
```
'SelmerCartanMotiveTowers.sol_thm_role_separated_objectification' depends on axioms: [propext,
 Classical.choice,
 Quot.sound]
```
Classification: Lean base axioms.
**Change from previous audit:** was axiom-free (vacuous empty model); the
P1-2 strengthening (nontrivial model with `channel_index`, at least one
edge with legal support) now requires the standard base-axiom triple.

### `SelmerCartanMotiveTowers.sol_thm_finite_motivic_recursion_closure` (M8)
```
'SelmerCartanMotiveTowers.sol_thm_finite_motivic_recursion_closure' depends on axioms: [propext,
 Classical.choice,
 Quot.sound]
```
Classification: Lean base axioms.

### `SelmerCartanMotiveTowers.sol_thm_successor_stage_functor` (M9)
```
'SelmerCartanMotiveTowers.sol_thm_successor_stage_functor' does not depend on any axioms
```
Classification: no axioms (pure construction from hypotheses).

### `SelmerCartanMotiveTowers.sol_thm_prime_power_comparison` (M10)
```
'SelmerCartanMotiveTowers.sol_thm_prime_power_comparison' depends on axioms: [propext, Classical.choice, Quot.sound]
```
Classification: Lean base axioms. Background hypotheses: `WitnessBackground`.

### `SelmerCartanMotiveTowers.sol_thm_classical_low_sector_comparison` (M11)
```
'SelmerCartanMotiveTowers.sol_thm_classical_low_sector_comparison' depends on axioms: [SelmerCartanMotiveTowers.tau_one]
```
Classification: project axiom `tau_one` (same inheritance chain as M2).
Background hypotheses: `FormalBackground`.

### `SelmerCartanMotiveTowers.sol_prop_stack_globalization` (M12)
```
'SelmerCartanMotiveTowers.sol_prop_stack_globalization' depends on axioms: [SelmerCartanMotiveTowers.tau_one]
```
Classification: project axiom `tau_one` (same inheritance chain as M2).
Background hypotheses: `FormalBackground`.

### `SelmerCartanMotiveTowers.sol_thm_marked_morita_independence` (M13)
```
'SelmerCartanMotiveTowers.sol_thm_marked_morita_independence' depends on axioms: [SelmerCartanMotiveTowers.tau_one]
```
Classification: project axiom `tau_one` (same inheritance chain as M2).
Background hypotheses: `FormalBackground`.

### `SelmerCartanMotiveTowers.sol_thm_31adic_witness` (M14, main goal)
```
'SelmerCartanMotiveTowers.sol_thm_31adic_witness' depends on axioms: [propext, Classical.choice, Quot.sound]
```
Classification: Lean base axioms. Background hypotheses: `WitnessBackground`.

### `SelmerCartanMotiveTowers.sol_thm_gerbe_provenance` (M15)
```
'SelmerCartanMotiveTowers.sol_thm_gerbe_provenance' depends on axioms: [propext, Classical.choice, Quot.sound]
```
Classification: Lean base axioms. Background hypotheses: `WitnessBackground`.

### `SelmerCartanMotiveTowers.sol_thm_motivic_specialization` (M16)
```
'SelmerCartanMotiveTowers.sol_thm_motivic_specialization' depends on axioms: [propext, Classical.choice, Quot.sound]
```
Classification: Lean base axioms. Background hypotheses: `WitnessBackground`.

---

## Summary table

| Declaration | Axioms |
|---|---|
| `tau_one` | [tau_one] (self) |
| `depth_of_full` | [depth_of_full] (self) |
| `depth_of_rec` | [depth_of_rec] (self) |
| `tau_one_depth_fiber` | all four project axioms |
| `full_mot`, `rec_one_mot` (opaques) | none |
| 6 package instances (§3) | [propext, Classical.choice, Quot.sound] |
| M1, M3, M4, M6, M8, M10, M14, M15, M16 | [propext, Classical.choice, Quot.sound] |
| M5 | [propext, Classical.choice, Quot.sound] (was [propext]) |
| M7 | [propext, Classical.choice, Quot.sound] (was none) |
| M9 | none |
| M2, M11, M12, M13 | [tau_one] via FormalBackground chain |

## Differences from the previous audit (2026-10-09, pre-P0-1/P0-2/P1-2)

1. **Coverage 22 → 28 declarations**: the 6 new package instance
   declarations (§3) are audited — all depend only on Lean base axioms.
2. **M5** (`sol_thm_motivic_seed`): `[propext]` → full triple, due to the
   P0-2 cohomology layer.
3. **M7** (`sol_thm_role_separated_objectification`): no axioms → full
   triple, due to the P1-2 nontrivial-model strengthening.
4. Everything else unchanged. **Still 0 `sorryAx` across all declarations.**
