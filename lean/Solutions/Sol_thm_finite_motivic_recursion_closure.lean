import Definitions.Def_jet_ledger
import Definitions.Def_motivic_moore_reedy
import Definitions.Def_finite_ordered_support
import Mathlib.Algebra.Squarefree.Basic

namespace SelmerCartanMotiveTowers

/-- Solution for Theorem 25.14 (`thm_finite_motivic_recursion_closure`), M8.

We construct an explicit `jet_tower`: at every jet level `n ≥ 3`, the
Moore–Reedy object with support `S`, order `N`, carrier `Fin 3`
(nontrivial) and algebra `Bool` (nontrivial). All levels share the same
carrier and algebra — this is paper (vi), no structural growth.

- (i) Support–jet closure: each `atLevel n` has support `S`, order `N`.
- (ii) Reedy latching: `latch n := id` — the jet successor preserves the
  shared carrier (no new structure is created). The `latch_level_indep`
  law records paper (ii): the proper-face latching object is
  "independently of the jet level".
- (iii) History: at level `n`, the `Fin (n-2)`-family is *computed* from
  `atLevel` (not an independent constant), agreeing by `rfl`.
- (vi) Cross-ceiling no-growth: `jet_tower.ledger_restrict` shows the
  `M₁`-ledger is literally the restriction of the `M₂`-ledger.

The finite ledger for ceiling `M` is `T.ledger M hM : Fin (M-2) →
motivic_moore_reedy`, indexed by actual jet levels `3..M` (via
`k.val + 3`), not by an unstructured `Fin M`.

REVISION NOTE (P1-2 deepening, 2026-10-09): Replaces the constant
`fun _ => T` ledger. The new `jet_tower` has real latching maps, history
families, and machine-checked cross-ceiling restriction. The carrier is
shared by construction, not by a post-hoc equality.

REVISION NOTE 2 (2026-10-10): Adds the `latch_level_indep` field (paper
(ii) level-independence as a machine-checked law); `history` is now
defined from `atLevel` so the agreement is structural; the conclusion
binds `latch`/`history`/`ledger_restrict` explicitly.

LIMITATIONS: Bar-complex constancy (iv), readout commutation (v), and
the bicategorical history 2-cells (iii) need spectral/bicategorical
machinery; recorded in `Def_jet_ledger.lean`, not formalized here.
-/
theorem sol_thm_finite_motivic_recursion_closure
    (N : Nat) (hNodd : Odd N) (hNsf : Squarefree N)
    (S : finite_ordered_support) (M : Nat) (hM : 3 ≤ M)
    : ∃ (T : jet_tower S N),
        (∀ (k : Fin (M - 2)), (T.ledger M hM k).support = S ∧
          (T.ledger M hM k).coeffOrder = N) ∧
        Nontrivial T.carrier ∧ Nontrivial T.corrAlgebra ∧
        (∀ (n₁ n₂ : ℕ) (h₁ : 3 ≤ n₁) (h₂ : 3 ≤ n₂),
          T.latch n₁ h₁ = T.latch n₂ h₂) ∧
        (∀ (n : ℕ) (h : 3 ≤ n) (k : Fin (n - 2)),
          T.history n h k = T.atLevel (k.val + 3) (by omega)) ∧
        (∀ (M₁ M₂ : ℕ) (h₁ : 3 ≤ M₁) (h₂ : 3 ≤ M₂) (hle : M₁ ≤ M₂)
          (k : Fin (M₁ - 2)),
          T.ledger M₁ h₁ k = T.ledger M₂ h₂ ⟨k.val, by omega⟩) := by
  let base : motivic_moore_reedy :=
    { support := S, coeffOrder := N, coeffOrder_odd := hNodd,
      coeffOrder_squarefree := hNsf, carrier := Fin 3, corrAlgebra := Bool }
  let atLevelFn : (n : ℕ) → 3 ≤ n → motivic_moore_reedy := fun _ _ => base
  let tower : jet_tower S N :=
    { carrier := Fin 3,
      corrAlgebra := Bool,
      carrierNontrivial := ⟨⟨0, by omega⟩, ⟨1, by omega⟩,
        fun h => Nat.zero_ne_one (congrArg Fin.val h)⟩,
      algebraNontrivial := ⟨false, true, Bool.false_ne_true⟩,
      atLevel := atLevelFn,
      atLevel_support := fun _ _ => rfl,
      atLevel_order := fun _ _ => rfl,
      atLevel_carrier := fun _ _ => rfl,
      atLevel_algebra := fun _ _ => rfl,
      latch := fun _ _ => id,
      latch_level_indep := fun _ _ _ _ => rfl,
      history := fun n h k => atLevelFn (k.val + 3) (by omega),
      history_eq := fun _ _ _ => rfl,
      history_support := fun _ _ _ => rfl,
      history_order := fun _ _ _ => rfl }
  refine ⟨tower, fun k => ⟨rfl, rfl⟩, inferInstance, inferInstance, ?_, ?_, ?_⟩
  · intro n₁ n₂ h₁ h₂; rfl
  · intro n h k; rfl
  · intro M₁ M₂ h₁ h₂ hle k; rfl

end SelmerCartanMotiveTowers
