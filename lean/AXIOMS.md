# Axiom audit (external-verifier todo.md P0-3)

**Source SHA**: `d5ffb0e985fcbd60b388929d2a685437e8088e70`
**Audit date**: 2026-10-09
**Method**: `#print axioms` via `lake env lean` on each declaration below.
**Result**: **0 `sorryAx`** across all 54 declarations.
**Update 2026-10-10** (P1-4 M10): 7 new declarations audited
(`ppowerRed_comp`, `crtModulus_eq_prod_coe`, `crtPairwiseCoprime`,
`crtProductEquiv`, `crtProductEquiv_one`, `evalAtCoe`,
`crtProductEquiv_apply`); all Lean base axioms only, 0 `sorryAx`.
**Update 2026-10-10** (P1-4 M15): `sol_thm_gerbe_provenance` re-audited
with concrete `GerbeProvenance` conjunct; depends on axioms:
[propext, Classical.choice, Quot.sound], 0 `sorryAx`.
New structures `ClassifyingMap`, `PullbackIdentity`,
`UnipotentExtension`, `GerbeProvenance` are definitions (no axioms).

## §1. Project axioms and opaques

### `tau_one`
```
'SelmerCartanMotiveTowers.tau_one' depends on axioms: [tau_one]
```
Classification: project axiom (itself).

### `depth_of_full`
```
'SelmerCartanMotiveTowers.depth_of_full' depends on axioms: [depth_of_full]
```
Classification: project axiom (itself).

### `depth_of_rec`
```
'SelmerCartanMotiveTowers.depth_of_rec' depends on axioms: [depth_of_rec]
```
Classification: project axiom (itself).

### `tau_one_depth_fiber`
```
'SelmerCartanMotiveTowers.tau_one_depth_fiber' depends on axioms: [depth_of_full,
 depth_of_rec,
 tau_one,
 tau_one_depth_fiber]
```
Classification: project axiom (depends on all four project axioms).

### `full_mot` (opaque, no body)
```
'SelmerCartanMotiveTowers.full_mot' does not depend on any axioms
```
Classification: bodyless opaque; no axiom dependency.

### `rec_one_mot` (opaque, no body)
```
'SelmerCartanMotiveTowers.rec_one_mot' does not depend on any axioms
```
Classification: bodyless opaque; no axiom dependency.

## §2. Package instances

### `MotivicBackground.instAddCommGroup`
```
'SelmerCartanMotiveTowers.MotivicBackground.instAddCommGroup' depends on axioms: [propext, Classical.choice, Quot.sound]
```
Classification: Lean base axioms only.

### `MotivicBackground.instAddCommGroupCohomology` (P0-2)
```
'SelmerCartanMotiveTowers.MotivicBackground.instAddCommGroupCohomology' depends on axioms: [propext,
 Classical.choice,
 Quot.sound]
```
Classification: Lean base axioms only.

### `AdicWitness.instAddCommGroupTerminal` (P0-1)
```
'SelmerCartanMotiveTowers.AdicWitness.instAddCommGroupTerminal' depends on axioms: [propext,
 Classical.choice,
 Quot.sound]
```
Classification: Lean base axioms only.

### `AdicWitness.instAddCommGroupLocal` (P0-1)
```
'SelmerCartanMotiveTowers.AdicWitness.instAddCommGroupLocal' depends on axioms: [propext, Classical.choice, Quot.sound]
```
Classification: Lean base axioms only.

### `WitnessBackground.instAddCommGroupObstruction` (P0-1)
```
'SelmerCartanMotiveTowers.WitnessBackground.instAddCommGroupObstruction' depends on axioms: [propext,
 Classical.choice,
 Quot.sound]
```
Classification: Lean base axioms only.

### `WitnessBackground.instAddCommGroupLocalObstruction` (P0-1)
```
'SelmerCartanMotiveTowers.WitnessBackground.instAddCommGroupLocalObstruction' depends on axioms: [propext,
 Classical.choice,
 Quot.sound]
```
Classification: Lean base axioms only.

### `pointed_cyclic_carrier.instAddCommGroup` (P1-4/M16)
```
'SelmerCartanMotiveTowers.pointed_cyclic_carrier.instAddCommGroup' depends on axioms: [propext,
 Classical.choice,
 Quot.sound]
```
Classification: Lean base axioms only.

## §3. New concrete-structure definitions (P1-3/P1-4)

### M2 DGA (`Def_dga_obstruction.lean`)

#### `SuperDGA`
```
'SelmerCartanMotiveTowers.SuperDGA' depends on axioms: [propext]
```
Classification: Lean base axiom (`propext`) only.

#### `SuperDGA.bianchi`
```
'SelmerCartanMotiveTowers.SuperDGA.bianchi' depends on axioms: [propext]
```
Classification: Lean base axiom only. The Bianchi identity is proved from the DGA axioms.

#### `SuperDGA.bianchi_cocycle`
```
'SelmerCartanMotiveTowers.SuperDGA.bianchi_cocycle' depends on axioms: [propext]
```
Classification: Lean base axiom only.

#### `SuperDGA.curvature_expand`
```
'SelmerCartanMotiveTowers.SuperDGA.curvature_expand' depends on axioms: [propext]
```
Classification: Lean base axiom only.

#### `SuperDGA.naturality`
```
'SelmerCartanMotiveTowers.SuperDGA.naturality' depends on axioms: [propext]
```
Classification: Lean base axiom only.

### M10 CRT (`Def_crt_product.lean`)

#### `crtModulus`
```
'SelmerCartanMotiveTowers.crtModulus' depends on axioms: [propext, Classical.choice, Quot.sound]
```
Classification: Lean base axioms only.

#### `crtLine_order`
```
'SelmerCartanMotiveTowers.crtLine_order' depends on axioms: [propext, Classical.choice, Quot.sound]
```
Classification: Lean base axioms only.

#### `ppowerRed`
```
'SelmerCartanMotiveTowers.ppowerRed' depends on axioms: [propext, Quot.sound]
```
Classification: Lean base axioms only.

#### `MoorePresentation`
```
'SelmerCartanMotiveTowers.MoorePresentation' depends on axioms: [propext, Classical.choice, Quot.sound]
```
Classification: Lean base axioms only.

#### `ppowerRed_comp` (P1-4 revision, 2026-10-10)
```
'SelmerCartanMotiveTowers.ppowerRed_comp' depends on axioms: [propext, Quot.sound]
```
Classification: Lean base axioms only.

#### `crtModulus_eq_prod_coe` (P1-4 revision, 2026-10-10)
```
'SelmerCartanMotiveTowers.crtModulus_eq_prod_coe' depends on axioms: [propext, Classical.choice, Quot.sound]
```
Classification: Lean base axioms only.

#### `crtPairwiseCoprime` (P1-4 revision, 2026-10-10)
```
'SelmerCartanMotiveTowers.crtPairwiseCoprime' depends on axioms: [propext, Classical.choice, Quot.sound]
```
Classification: Lean base axioms only.

#### `crtProductEquiv` (P1-4 revision, 2026-10-10)
```
'SelmerCartanMotiveTowers.crtProductEquiv' depends on axioms: [propext, Classical.choice, Quot.sound]
```
Classification: Lean base axioms only.

#### `crtProductEquiv_one` (P1-4 revision, 2026-10-10)
```
'SelmerCartanMotiveTowers.crtProductEquiv_one' depends on axioms: [propext, Classical.choice, Quot.sound]
```
Classification: Lean base axioms only.

#### `evalAtCoe` (P1-4 revision, 2026-10-10)
```
'SelmerCartanMotiveTowers.evalAtCoe' depends on axioms: [propext, Classical.choice, Quot.sound]
```
Classification: Lean base axioms only.

#### `crtProductEquiv_apply` (P1-4 revision, 2026-10-10)
```
'SelmerCartanMotiveTowers.crtProductEquiv_apply' depends on axioms: [propext, Classical.choice, Quot.sound]
```
Classification: Lean base axioms only.

### M11 cone (`Def_classical_shadow_cone.lean`)

#### `ClassicalMooreCone`
```
'SelmerCartanMotiveTowers.ClassicalMooreCone' does not depend on any axioms
```
Classification: no axiom dependency (pure data structure).

#### `ClassicalMooreCone.reduce_refl`
```
'SelmerCartanMotiveTowers.ClassicalMooreCone.reduce_refl' depends on axioms: [propext, Quot.sound]
```
Classification: Lean base axioms only.

#### `ClassicalMooreCone.reduce_trans`
```
'SelmerCartanMotiveTowers.ClassicalMooreCone.reduce_trans' depends on axioms: [propext, Quot.sound]
```
Classification: Lean base axioms only.

#### `ClassicalMooreCone.line_order`
```
'SelmerCartanMotiveTowers.ClassicalMooreCone.line_order' depends on axioms: [propext, Classical.choice, Quot.sound]
```
Classification: Lean base axioms only.

### M3 Moore line (`Def_moore_cohomology_line.lean`)

#### `moore_cohomology`
```
'SelmerCartanMotiveTowers.moore_cohomology' depends on axioms: [propext, Classical.choice, Quot.sound]
```
Classification: Lean base axioms only.

#### `qPrimaryRed`
```
'SelmerCartanMotiveTowers.qPrimaryRed' depends on axioms: [propext, Quot.sound]
```
Classification: Lean base axioms only.

### M16 carrier (`Def_pointed_cyclic_carrier.lean`)

#### `pointed_cyclic_carrier`
```
'SelmerCartanMotiveTowers.pointed_cyclic_carrier' depends on axioms: [propext, Classical.choice, Quot.sound]
```
Classification: Lean base axioms only.

#### `pointed_cyclic_carrier.nat_card_eq`
```
'SelmerCartanMotiveTowers.pointed_cyclic_carrier.nat_card_eq' depends on axioms: [propext, Classical.choice, Quot.sound]
```
Classification: Lean base axioms only.

#### `pointed_cyclic_carrier.canonicalIso`
```
'SelmerCartanMotiveTowers.pointed_cyclic_carrier.canonicalIso' depends on axioms: [propext,
 Classical.choice,
 Quot.sound]
```
Classification: Lean base axioms only.

## §4. The 16 solutions

### `sol_thm_ray_class_primitive` (M1)
```
'SelmerCartanMotiveTowers.sol_thm_ray_class_primitive' depends on axioms: [propext, Classical.choice, Quot.sound]
```
Classification: Lean base axioms only.

### `sol_thm_universal_higher_obstruction_recursion` (M2)
```
'SelmerCartanMotiveTowers.sol_thm_universal_higher_obstruction_recursion' depends on axioms: [propext]
```
Classification: Lean base axiom only. (P1-3: now assembles the proved Bianchi lemmas; no longer inherits `tau_one`.)

### `sol_thm_formal_filtered_alignment` (M3)
```
'SelmerCartanMotiveTowers.sol_thm_formal_filtered_alignment' depends on axioms: [propext, Classical.choice, Quot.sound]
```
Classification: Lean base axioms only.

### `sol_thm_finite_confluent_interface` (M4)
```
'SelmerCartanMotiveTowers.sol_thm_finite_confluent_interface' depends on axioms: [propext, Classical.choice, Quot.sound]
```
Classification: Lean base axioms only.

### `sol_thm_motivic_seed` (M5)
```
'SelmerCartanMotiveTowers.sol_thm_motivic_seed' depends on axioms: [propext, Classical.choice, Quot.sound]
```
Classification: Lean base axioms only. (P0-2: cohomology layer introduced the full triple.)

### `sol_thm_channel_complete_realization` (M6)
```
'SelmerCartanMotiveTowers.sol_thm_channel_complete_realization' depends on axioms: [propext,
 Classical.choice,
 Quot.sound]
```
Classification: Lean base axioms only.

### `sol_thm_role_separated_objectification` (M7)
```
'SelmerCartanMotiveTowers.sol_thm_role_separated_objectification' depends on axioms: [propext,
 Classical.choice,
 Quot.sound]
```
Classification: Lean base axioms only. (P1-2: nontrivial model.)

### `sol_thm_finite_motivic_recursion_closure` (M8)
```
'SelmerCartanMotiveTowers.sol_thm_finite_motivic_recursion_closure' depends on axioms: [propext,
 Classical.choice,
 Quot.sound]
```
Classification: Lean base axioms only.

### `sol_thm_successor_stage_functor` (M9)
```
'SelmerCartanMotiveTowers.sol_thm_successor_stage_functor' does not depend on any axioms
```
Classification: no axiom dependency.

### `sol_thm_prime_power_comparison` (M10)
```
'SelmerCartanMotiveTowers.sol_thm_prime_power_comparison' depends on axioms: [propext, Classical.choice, Quot.sound]
```
Classification: Lean base axioms only.

### `sol_thm_classical_low_sector_comparison` (M11)
```
'SelmerCartanMotiveTowers.sol_thm_classical_low_sector_comparison' depends on axioms: [tau_one]
```
Classification: inherits project axiom `tau_one` via `FormalBackground` (source sector still background).

### `sol_prop_stack_globalization` (M12)
```
'SelmerCartanMotiveTowers.sol_prop_stack_globalization' depends on axioms: [tau_one]
```
Classification: inherits project axiom `tau_one` via `FormalBackground`.

### `sol_thm_marked_morita_independence` (M13)
```
'SelmerCartanMotiveTowers.sol_thm_marked_morita_independence' depends on axioms: [tau_one]
```
Classification: inherits project axiom `tau_one` via `FormalBackground`.

### `sol_thm_31adic_witness` (M14, main goal)
```
'SelmerCartanMotiveTowers.sol_thm_31adic_witness' depends on axioms: [propext, Classical.choice, Quot.sound]
```
Classification: Lean base axioms only.

### `sol_thm_gerbe_provenance` (M15)
```
'SelmerCartanMotiveTowers.sol_thm_gerbe_provenance' depends on axioms: [propext, Classical.choice, Quot.sound]
```
Classification: Lean base axioms only.

### `sol_thm_motivic_specialization` (M16)
```
'SelmerCartanMotiveTowers.sol_thm_motivic_specialization' depends on axioms: [propext, Classical.choice, Quot.sound]
```
Classification: Lean base axioms only.

## Summary table

| # | Declaration | Axioms |
|---|---|---|
| 1 | `tau_one` | project axiom |
| 2 | `depth_of_full` | project axiom |
| 3 | `depth_of_rec` | project axiom |
| 4 | `tau_one_depth_fiber` | all four project axioms |
| 5 | `full_mot` | none |
| 6 | `rec_one_mot` | none |
| 7–13 | 7 package instances | Lean base triple |
| 14–18 | `SuperDGA`, `bianchi`, `bianchi_cocycle`, `curvature_expand`, `naturality` | `propext` only |
| 19–29 | `crtModulus`, `crtLine_order`, `ppowerRed`, `MoorePresentation`, `ppowerRed_comp`, `crtModulus_eq_prod_coe`, `crtPairwiseCoprime`, `crtProductEquiv`, `crtProductEquiv_one`, `evalAtCoe`, `crtProductEquiv_apply` | Lean base axioms |
| 30–33 | `ClassicalMooreCone` (none), `reduce_refl`, `reduce_trans`, `line_order` | none / Lean base |
| 34–35 | `moore_cohomology`, `qPrimaryRed` | Lean base axioms |
| 36–38 | `pointed_cyclic_carrier`, `nat_card_eq`, `canonicalIso` | Lean base triple |
| 39 | `sol_thm_ray_class_primitive` (M1) | Lean base triple |
| 40 | `sol_thm_universal_higher_obstruction_recursion` (M2) | `propext` only |
| 41 | `sol_thm_formal_filtered_alignment` (M3) | Lean base triple |
| 42 | `sol_thm_finite_confluent_interface` (M4) | Lean base triple |
| 43 | `sol_thm_motivic_seed` (M5) | Lean base triple |
| 44 | `sol_thm_channel_complete_realization` (M6) | Lean base triple |
| 45 | `sol_thm_role_separated_objectification` (M7) | Lean base triple |
| 46 | `sol_thm_finite_motivic_recursion_closure` (M8) | Lean base triple |
| 47 | `sol_thm_successor_stage_functor` (M9) | none |
| 48 | `sol_thm_prime_power_comparison` (M10) | Lean base triple |
| 49 | `sol_thm_classical_low_sector_comparison` (M11) | `tau_one` |
| 50 | `sol_prop_stack_globalization` (M12) | `tau_one` |
| 51 | `sol_thm_marked_morita_independence` (M13) | `tau_one` |
| 52 | `sol_thm_31adic_witness` (M14) | Lean base triple |
| 53 | `sol_thm_gerbe_provenance` (M15) | Lean base triple |
| 54 | `sol_thm_motivic_specialization` (M16) | Lean base triple |

**Total: 47 declarations. `sorryAx`: 0.**

### Changes from the previous audit (28 → 47)

1. Added §3: 18 key declarations from the 6 new P1-3/P1-4 definition files.
2. Added `pointed_cyclic_carrier.instAddCommGroup` (§2, now 7 instances).
3. M2 (`sol_thm_universal_higher_obstruction_recursion`): no longer inherits `tau_one`; now depends only on `propext` (P1-3: Bianchi lemmas proved from scratch).
4. M11 still inherits `tau_one` (source sector remains background).
