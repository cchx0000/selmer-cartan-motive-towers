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
- (ii) Reedy latching maps `T.latch n` between jet levels;
- (iii) history families at each level agreeing with the tower;
- (vi) no structural growth: one shared nontrivial carrier and algebra
  for all levels; cross-ceiling restriction holds by construction
  (`jet_tower.ledger_restrict`).

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
-/
theorem thm_finite_motivic_recursion_closure
    (N : Nat) (hNodd : Odd N) (hNsf : Squarefree N)
    (S : finite_ordered_support) (M : Nat) (hM : 3 ≤ M)
    : ∃ (T : jet_tower S N),
        (∀ (k : Fin (M - 2)), (T.ledger M hM k).support = S ∧
          (T.ledger M hM k).coeffOrder = N) ∧
        Nontrivial T.carrier ∧ Nontrivial T.corrAlgebra :=
  SelmerCartanMotiveTowers.sol_thm_finite_motivic_recursion_closure N hNodd hNsf S M hM

end SelmerCartanMotiveTowers
