import Definitions.Def_jet_ledger
import Definitions.Def_motivic_moore_reedy
import Definitions.Def_finite_ordered_support
import Mathlib.Algebra.Squarefree.Basic
import Solutions.Sol_thm_finite_motivic_recursion_closure

namespace SelmerCartanMotiveTowers

/-- Finite motivic Moore–Reedy recursion closure (Theorem 25.14,
`P2M-thm:v38-finite-motivic-recursion-closure`): fix an odd squarefree
coefficient order `N`, a finite ordered support `S`, and a finite jet
ceiling `M ≥ 3`. There exists a jet tower `T : jet_tower S N`
(`Definitions/Def_jet_ledger.lean`) such that the finite ledger
`T.ledger M hM : Fin (M-2) → motivic_moore_reedy` — indexed by actual
jet levels `3..M` — satisfies:

- (i) support–jet closure: every ledger entry has support `S` and
  coefficient order `N`;
- (ii) Reedy latching maps `T.latch n` between jet levels, independent
  of `n` (`T.latch_level_indep`);
- (iii) history families `T.history n h` at each level agreeing with the
  tower (`T.history_eq`);
- (vi) no structural growth: one shared nontrivial carrier and algebra
  for all levels; cross-ceiling restriction holds by construction
  (`jet_tower.ledger_restrict`), with an explicit instance below.

In particular `M` occurs in the conclusion (via `Fin (M-2)`), the jet
levels are `3 ≤ n ≤ M` (not an unstructured `Fin M`), and "jet preserves
the underlying object" is distinguished from "deletes everything" (the
shared carrier is nontrivial).

REVISION NOTE (P1-2 deepening, 2026-10-09): The previous proof used a
constant `fun _ => T` ledger over `Fin M`. The new statement uses
`jet_tower` with real latching maps, history families, and
machine-checked cross-ceiling restriction. Bar-complex constancy (iv),
readout commutation (v), and bicategorical history 2-cells (iii) remain
as documented limitations.

REVISION NOTE 2 (2026-10-10): The conclusion now explicitly binds the
`latch`/`history` fields (with the `latch_level_indep` law) and includes
a concrete `ledger_restrict` instance, so the tower structure cannot be
witnessed by a weakened re-quantification.
-/
theorem thm_finite_motivic_recursion_closure
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
          T.ledger M₁ h₁ k = T.ledger M₂ h₂ ⟨k.val, by omega⟩) :=
  SelmerCartanMotiveTowers.sol_thm_finite_motivic_recursion_closure N hNodd hNsf S M hM

end SelmerCartanMotiveTowers
