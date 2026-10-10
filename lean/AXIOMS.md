# Axiom audit (external-verifier todo.md P0-3)

**Source SHA**: `d5ffb0e985fcbd60b388929d2a685437e8088e70`
**Audit date**: 2026-10-09
**Method**: `#print axioms` via `lake env lean` on each declaration below.
**Result**: **0 `sorryAx`** across all 59 declarations.
**Update 2026-10-10** (M2 Leibniz fix): 1 new declaration audited
(`SuperDGA.leibniz_of_decomp`, linear extension of the Leibniz rule to
mixed elements); depends on axioms: [propext] only, 0 `sorryAx`. The old
single `leibniz` field (`if isOdd a`) was replaced by the homogeneous
fields `leibniz_even` / `leibniz_odd` (structure fields, not tabled).
**Update 2026-10-10** (P1-4 M3 round 2, `e122cfaf`): 4 new named
declarations audited (`moore_cohomology_apply_mk`,
`moore_cohomology_of_diff`, `moore_cohomology_of_diff_apply_mk`,
`mooreGen_is_cohomology_class_proof`); all Lean base axioms only, 0
`sorryAx`.
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

#### `SuperDGA.leibniz_of_decomp`
```
'SelmerCartanMotiveTowers.SuperDGA.leibniz_of_decomp' depends on axioms: [propext]
```
Classification: Lean base axiom only. Linear extension of the Leibniz rule
to mixed elements along the even/odd decomposition.

**Revision note (2026-10-10, M2 Leibniz fix):** the old single `leibniz`
field (`if isOdd a`) mis-signed mixed elements and excluded the standard
super-DGA model `Λ_ℚ(θ)`, `dθ = 1`. It is replaced by the homogeneous
fields `leibniz_even` / `leibniz_odd` (structure fields, not tabled) plus
the proved linear extension `leibniz_of_decomp` above.
`GaugeUnit` now requires evenness as subgroup membership (`g ∈ evenPart`);
`DGAHom` preserves parity as subgroup membership (a nonzero odd element
may map to `0`). The declaration total moves 58 → 59 (see summary-table
row 18a and the §4 change log).

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

#### `moore_cohomology_apply_mk` (2026-10-10, verifier P1-4 M3 round 2)
```
'SelmerCartanMotiveTowers.moore_cohomology_apply_mk' depends on axioms: [propext, Classical.choice, Quot.sound]
```
Classification: Lean base axioms only. Proved by `rfl`: the explicit
`trans` construction computes definitionally (`mk x ↦ mk x ↦ Int.cast x`).

#### `moore_cohomology_of_diff` (2026-10-10, verifier P1-4 M3 round 2)
```
'SelmerCartanMotiveTowers.moore_cohomology_of_diff' depends on axioms: [propext, Classical.choice, Quot.sound]
```
Classification: Lean base axioms only. Range-factored identification
`ℤ ⧸ range (mooreDiff p q) ≃+ moore_line p q`, built from `mooreDiff_range`.

#### `moore_cohomology_of_diff_apply_mk` (2026-10-10, verifier P1-4 M3 round 2)
```
'SelmerCartanMotiveTowers.moore_cohomology_of_diff_apply_mk' depends on axioms: [propext, Classical.choice, Quot.sound]
```
Classification: Lean base axioms only.

#### `mooreGen_is_cohomology_class_proof` (2026-10-10, verifier P1-4 M3 round 2)
```
'SelmerCartanMotiveTowers.mooreGen_is_cohomology_class_proof' depends on axioms: [propext, Classical.choice, Quot.sound]
```
Classification: Lean base axioms only. Proves the former named-`Prop`
`mooreGen_is_cohomology_class`: `[B_{2,1}] = [1] ↦ mooreGen`.

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
| 18a | `leibniz_of_decomp` (2026-10-10, M2 Leibniz fix) | `propext` only |
| 19–29 | `crtModulus`, `crtLine_order`, `ppowerRed`, `MoorePresentation`, `ppowerRed_comp`, `crtModulus_eq_prod_coe`, `crtPairwiseCoprime`, `crtProductEquiv`, `crtProductEquiv_one`, `evalAtCoe`, `crtProductEquiv_apply` | Lean base axioms |
| 30–33 | `ClassicalMooreCone` (none), `reduce_refl`, `reduce_trans`, `line_order` | none / Lean base |
| 34–35 | `moore_cohomology`, `qPrimaryRed` | Lean base axioms |
| 34a–34d | `moore_cohomology_apply_mk`, `moore_cohomology_of_diff`, `moore_cohomology_of_diff_apply_mk`, `mooreGen_is_cohomology_class_proof` (2026-10-10, P1-4 M3 round 2) | Lean base axioms |
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

**Total: 59 declarations. `sorryAx`: 0.**

### Changes from the 47-item audit (47 → 59)

1. Added 7 P1-4 M10 CRT declarations (2026-10-10): `ppowerRed_comp`,
   `crtModulus_eq_prod_coe`, `crtPairwiseCoprime`, `crtProductEquiv`,
   `crtProductEquiv_one`, `evalAtCoe`, `crtProductEquiv_apply` — all Lean
   base axioms only, 0 `sorryAx`.
2. `sol_thm_gerbe_provenance` (M15) re-audited with the concrete
   `GerbeProvenance` conjunct (2026-10-10): [propext, Classical.choice,
   Quot.sound], 0 `sorryAx`. The new structures `ClassifyingMap`,
   `PullbackIdentity`, `UnipotentExtension`, `GerbeProvenance` are
   definitions (no axioms); `unipotentExtensionModel` is a definition too.
3. Added 4 P1-4 M3 round-2 declarations (2026-10-10, `e122cfaf`):
   `moore_cohomology_apply_mk`, `moore_cohomology_of_diff`,
   `moore_cohomology_of_diff_apply_mk`, `mooreGen_is_cohomology_class_proof`
   — all Lean base axioms only, 0 `sorryAx`. They close the
   `[1] → mooreGen → confGen` generator chain in proof steps; see §3
   entries and summary-table rows 34a–34d.
4. Coverage note: the per-item audit source SHA
   `d5ffb0e985fcbd60b388929d2a685437e8088e70` is not resolvable via the
   repository API (verifier: 422), and later source changes (M16
   `witnessArithIso`/`hM`, M6 `omegaClass`/`reesCoeff`, M7 `ControlEdge`,
   M8 `ReedyDecomp`, P0-0 `UnipotentExtension` fields, M15 re-revision)
   are not yet covered by a per-item `#print axioms` rerun; see P0-3.
   Two staged exceptions are recorded precisely, not as whole-module
   coverage claims:
   - M3 round-2 (`e122cfaf`): the four named declarations
     `moore_cohomology_apply_mk`, `moore_cohomology_of_diff`,
     `moore_cohomology_of_diff_apply_mk`,
     `mooreGen_is_cohomology_class_proof` each have an author
     `#print axioms` audit (Lean base axioms only; §3 entries and
     summary-table rows 34a–34d). This does not extend to the rest of
     the M3 generator-chain dependencies (range / filtered-interface
     fields and the remaining `Def_moore_two_term` declarations), which
     remain unaudited per-item at a resolvable source.
   - M2 (`e3c1a70a`): `SuperDGA.leibniz_of_decomp` has an author
     `#print axioms` audit ([propext] only; §3 entry, row 18a). That
     single named output does not substitute for the revised
     `SuperDGA`/`GaugeUnit`/`DGAHom` fields or the production M2
     solution's dependency closure under the revised definitions —
     the row-40 audit of `sol_thm_universal_higher_obstruction_recursion`
     predates the Leibniz-interface fix and has not been rerun per-item
     since.
   The 59-item table records the declarations as listed at audit time,
   not a claim that every current module has been rerun.
5. Added 1 M2 declaration (2026-10-10, Leibniz fix):
   `SuperDGA.leibniz_of_decomp` — [propext] only, 0 `sorryAx`; see §3
   entry and summary-table row 18a. The old single `leibniz` field
   (`if isOdd a`) was replaced by `leibniz_even` / `leibniz_odd`
   (structure fields, not tabled); `GaugeUnit` / `DGAHom` parity fields
   were also revised (subgroup membership).

### Changes from the previous audit (28 → 47)

1. Added §3: 18 key declarations from the 6 new P1-3/P1-4 definition files.
2. Added `pointed_cyclic_carrier.instAddCommGroup` (§2, now 7 instances).
3. M2 (`sol_thm_universal_higher_obstruction_recursion`): no longer inherits `tau_one`; now depends only on `propext` (P1-3: Bianchi lemmas proved from scratch).
4. M11 still inherits `tau_one` (source sector remains background).
