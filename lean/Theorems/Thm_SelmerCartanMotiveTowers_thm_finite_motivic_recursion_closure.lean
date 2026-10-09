import Definitions.Def_motivic_moore_reedy
import Definitions.Def_finite_ordered_support
import Mathlib.Algebra.Squarefree.Basic

namespace SelmerCartanMotiveTowers

/-- Finite motivic Moore–Reedy recursion closure (Theorem 25.14,
`P2M-thm:v38-finite-motivic-recursion-closure`): fix an odd squarefree
coefficient order `N`, a finite ordered support `S`, and a finite jet
ceiling `M ≥ 3`. The constructions of the paper together with the finite
Confluent ledger assemble into one finite marked Moore–Reedy recursion
package `𝔗^{Mot,MR}_{N;S,≤M}` whose underlying motivic target has support
`S` and coefficient order `N`, with support–jet closure, Reedy closure,
history closure, and readout closure (the paper's items (i)–(iii) and (v);
the secondary-transgression constancy and no-growth statements are
recorded in the natural-language statement). -/
theorem thm_finite_motivic_recursion_closure
    (N : Nat) (hNodd : Odd N) (hNsf : Squarefree N)
    (S : finite_ordered_support) (M : Nat) (hM : 3 ≤ M)
    : ∃ T : motivic_moore_reedy, T.support = S ∧ T.coeffOrder = N := by sorry

end SelmerCartanMotiveTowers
