import Definitions.Def_motivic_moore_reedy
import Definitions.Def_finite_ordered_support
import Mathlib.Algebra.Squarefree.Basic

namespace SelmerCartanMotiveTowers

/-- Solution for Theorem 19.6 (`thm_channel_complete_realization`), M6.

The paper (`P2M-thm:channel-complete-realization`) constructs, for every finite
ordered support `S` and odd squarefree `N` with the genuine pure-weight root
pair fixed, the dg realization
`ρ_S^{Mot,MR} : U^{rec}_{S,N} → M_{S,N}^{Mot,MR}`.

The Lean draft records the existence statement only: some source type, some
`motivic_moore_reedy` target with `support = S` and `coeffOrder = N`, and a
realization map out of a nonempty source. The carrier and algebra are opaque
in the definition, so the witness is direct: `Source := Unit`,
`M := { support := S, coeffOrder := N, coeffOrder_odd := hNodd,
        coeffOrder_squarefree := hNsf, carrier := Unit, corrAlgebra := Unit }`,
`ρ := fun _ => ()`. The two equalities close by `rfl` (definitional projection
reduction on the inline structure instance); `Nonempty Unit` is `⟨()⟩`. -/
theorem solution
    (S : finite_ordered_support) (N : Nat) (hNodd : Odd N) (hNsf : Squarefree N)
    : ∃ (Source : Type) (M : motivic_moore_reedy) (ρ : Source → M.carrier),
        M.support = S ∧ M.coeffOrder = N ∧ Nonempty Source :=
  ⟨Unit,
   { support := S, coeffOrder := N, coeffOrder_odd := hNodd,
     coeffOrder_squarefree := hNsf, carrier := Unit, corrAlgebra := Unit },
   fun _ => (), rfl, rfl, ⟨()⟩⟩

end SelmerCartanMotiveTowers
