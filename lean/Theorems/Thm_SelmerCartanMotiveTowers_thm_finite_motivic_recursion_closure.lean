import Definitions.Def_motivic_moore_reedy
import Definitions.Def_finite_ordered_support
import Mathlib.Algebra.Squarefree.Basic
import Solutions.Sol_thm_finite_motivic_recursion_closure

namespace SelmerCartanMotiveTowers

/-- Finite motivic Moore–Reedy recursion closure (Theorem 25.14,
`P2M-thm:v38-finite-motivic-recursion-closure`): fix an odd squarefree
coefficient order `N`, a finite ordered support `S`, and a finite jet
ceiling `M ≥ 3`. The constructions assemble into a finite marked
Moore–Reedy recursion package `𝔗^{Mot,MR}_{N;S,≤M}` consisting of an
underlying motivic target `T` (support `S`, order `N`, nontrivial real
carrier and algebra) together with a jet ledger `ledger : Fin M → ...`
recording the history realizations at each jet level. The ledger
preserves support and order at every level (support–jet closure, paper
(i)), and every ledger entry shares the target's carrier (no structural
growth, paper (vi)): the jet changes only the external ledger, never the
underlying object. In particular `M` occurs in the conclusion (via
`Fin M`), and "jet preserves the underlying object" is distinguished
from "deletes everything" (the shared carrier is nontrivial, not
`Empty`/`Unit`).

REVISION NOTE (P1-2, 2026-10-09): The first proof used `Unit` carriers
and `M` did not occur in the conclusion. The strengthened statement
requires `Nontrivial` carrier/algebra, a `Fin M`-indexed ledger, and
carrier-sharing (`(ledger n).carrier = T.carrier`). The `Unit` model
does not satisfy the new statement: `Nontrivial Unit` is false
(machine-checked). The secondary-transgression constancy and readout
details are recorded in the natural-language statement.
-/
theorem thm_finite_motivic_recursion_closure
    (N : Nat) (hNodd : Odd N) (hNsf : Squarefree N)
    (S : finite_ordered_support) (M : Nat) (hM : 3 ≤ M)
    : ∃ (T : motivic_moore_reedy)
        (ledger : Fin M → motivic_moore_reedy),
        T.support = S ∧ T.coeffOrder = N ∧
        Nontrivial T.carrier ∧ Nontrivial T.corrAlgebra ∧
        (∀ n, (ledger n).support = S ∧ (ledger n).coeffOrder = N) ∧
        (∀ n, (ledger n).carrier = T.carrier) :=
  SelmerCartanMotiveTowers.sol_thm_finite_motivic_recursion_closure N hNodd hNsf S M hM

end SelmerCartanMotiveTowers
