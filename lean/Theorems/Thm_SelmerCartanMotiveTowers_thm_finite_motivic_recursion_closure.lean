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
  coefficient order `N`; support deletion commutes with the jet
  successor (`T.del_succ_comm`);
- (ii) Reedy latching maps `T.latch n` between jet levels, independent
  of `n` (`T.latch_level_indep`); the Reedy decomposition has a
  square-zero differential (`∀ x, d (d x) = 0`), an ℕ-grading with `d`
  raising degree on nonzero values, the `dγ = Nβ` relation with `β` of
  *exact* order `N` (ruling out the degenerate zero Moore pair), and a
  Boolean saturation map additive on disjoint unions — all stated with
  the tower's own `ReedyDecomp` instances in scope (`letI`), and proved
  from the corresponding `ReedyDecomp` fields in the witness;
- (iii) history families `T.history n h` at each level agreeing with the
  tower (`T.history_eq`); reduced insertion histories are irredundant
  (`T.redHist_nodup`) and complete (`T.redHist_complete`), and the
  closed history blocks are exactly the reduced-history entries
  (`T.histBlocks_eq`);
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

REVISION NOTE 3 (2026-10-10): The conclusion now also binds the
Reedy/face compatibility laws: `del_succ_comm` (support deletion
commutes with jet successor, paper (i)), and `reedy.d_gamma_eq`
(the `dγ = Nβ` relation from the Reedy decomposition, paper (ii)).

REVISION NOTE 4 (2026-10-10): The conclusion now states the full
Reedy/history content as proved laws (with the tower's `ReedyDecomp`
instances in scope via `letI`, since bound-tower projections need no
typeclass synthesis), so (ii) and (iii) are closed by genuine
mathematics rather than naming alone: `d² = 0`, the grading law,
`dγ = Nβ` with exact order `N` of `β` (ruling out the degenerate zero
Moore pair), the Boolean saturation map law, and the
reduced-history/block laws (`T.redHist_nodup`, `T.redHist_complete`,
`T.histBlocks_eq`). The witness (in
`Solutions/Sol_thm_finite_motivic_recursion_closure.lean`) provides
these via the `ReedyDecomp` fields (`d_sq_zero`, `d_degree`,
`d_gamma_eq`, `beta_order`, `satMap_disjoint_union`) using a nonzero
square-zero differential, a nonzero Moore antecedent, and a real
saturation lattice map.
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
          T.ledger M₁ h₁ k = T.ledger M₂ h₂ ⟨k.val, by omega⟩) ∧
        (∀ (T₀ : Finset ↥S.primes) (n : ℕ) (h : 3 ≤ n) (x : T.carrier),
          T.delMap T₀ (T.latch n h x) = T.latch n h (T.delMap T₀ x)) ∧
        (letI := T.reedy.carrierAdd; ∀ x : T.carrier, T.reedy.d (T.reedy.d x) = 0) ∧
        (letI := T.reedy.carrierAdd; ∀ x : T.carrier, T.reedy.d x ≠ 0 →
          T.reedy.grade (T.reedy.d x) = T.reedy.grade x + 1) ∧
        (letI := T.reedy.carrierAdd; T.reedy.d T.reedy.gamma = N • T.reedy.beta) ∧
        (letI := T.reedy.carrierAdd; addOrderOf T.reedy.beta = N) ∧
        (letI := T.reedy.carrierAdd; letI := T.reedy.satAdd;
          ∀ T₁ T₂ : Finset ↥S.primes, Disjoint T₁ T₂ →
            T.reedy.satMap (T₁ ∪ T₂) = T.reedy.satMap T₁ + T.reedy.satMap T₂) ∧
        (∀ (n : ℕ) (h : 3 ≤ n), (T.redHist n h).Nodup) ∧
        (∀ (n : ℕ) (h : 3 ≤ n) (k : Fin (n - 2)), k ∈ T.redHist n h) ∧
        (∀ (n : ℕ) (h : 3 ≤ n), T.histBlocks n h = (T.redHist n h).toFinset) :=
  SelmerCartanMotiveTowers.sol_thm_finite_motivic_recursion_closure N hNodd hNsf S M hM

end SelmerCartanMotiveTowers
