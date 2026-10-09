import Definitions.Def_motivic_moore_reedy
import Definitions.Def_finite_ordered_support
import Mathlib.Algebra.Squarefree.Basic

namespace SelmerCartanMotiveTowers

/-- Solution for Theorem 25.14 (`thm_finite_motivic_recursion_closure`), M8.

Direct assembly: the conclusion is the existential package itself. We take
the opaque carriers to be `Unit` and supply the hypotheses `hNodd`, `hNsf`
as the structure's `coeffOrder_odd` / `coeffOrder_squarefree` fields. The
projections `support` / `coeffOrder` reduce definitionally on the inline
instance, so the equations close by `rfl`. -/
theorem solution
    (N : Nat) (hNodd : Odd N) (hNsf : Squarefree N)
    (S : finite_ordered_support) (M : Nat) (hM : 3 ≤ M)
    : ∃ T : motivic_moore_reedy, T.support = S ∧ T.coeffOrder = N :=
  ⟨{ support := S, coeffOrder := N, coeffOrder_odd := hNodd,
     coeffOrder_squarefree := hNsf, carrier := Unit, corrAlgebra := Unit },
   rfl, rfl⟩

end SelmerCartanMotiveTowers
