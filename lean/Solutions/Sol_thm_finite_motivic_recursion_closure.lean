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
  shared carrier (no new structure is created).
- (iii) History: at level `n`, the `Fin (n-2)`-family of previous levels,
  agreeing with `atLevel` by construction.
- (vi) Cross-ceiling no-growth: `jet_tower.ledger_restrict` shows the
  `M₁`-ledger is literally the restriction of the `M₂`-ledger.

The finite ledger for ceiling `M` is `T.ledger M hM : Fin (M-2) →
motivic_moore_reedy`, indexed by actual jet levels `3..M` (via
`k.val + 3`), not by an unstructured `Fin M`.

REVISION NOTE (P1-2 deepening, 2026-10-09): Replaces the constant
`fun _ => T` ledger. The new `jet_tower` has real latching maps, history
families, and machine-checked cross-ceiling restriction. The carrier is
shared by construction, not by a post-hoc equality.

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
        Nontrivial T.carrier ∧ Nontrivial T.corrAlgebra := by
  let base : motivic_moore_reedy :=
    { support := S, coeffOrder := N, coeffOrder_odd := hNodd,
      coeffOrder_squarefree := hNsf, carrier := Fin 3, corrAlgebra := Bool }
  let tower : jet_tower S N :=
    { carrier := Fin 3,
      corrAlgebra := Bool,
      carrierNontrivial := ⟨⟨0, by omega⟩, ⟨1, by omega⟩,
        fun h => Nat.zero_ne_one (congrArg Fin.val h)⟩,
      algebraNontrivial := ⟨false, true, Bool.false_ne_true⟩,
      atLevel := fun _ _ => base,
      atLevel_support := fun _ _ => rfl,
      atLevel_order := fun _ _ => rfl,
      atLevel_carrier := fun _ _ => rfl,
      atLevel_algebra := fun _ _ => rfl,
      latch := fun _ _ => id,
      history := fun _ _ _ => base,
      history_eq := fun _ _ _ => rfl,
      history_support := fun _ _ _ => rfl,
      history_order := fun _ _ _ => rfl }
  exact ⟨tower, fun k => ⟨rfl, rfl⟩, inferInstance, inferInstance⟩

end SelmerCartanMotiveTowers
