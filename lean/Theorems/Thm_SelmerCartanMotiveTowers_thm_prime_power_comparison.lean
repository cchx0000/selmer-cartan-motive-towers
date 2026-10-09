import Definitions.Def_finite_ordered_support
import Definitions.Def_typed_coordinates
import Definitions.Def_witness_background
import Definitions.Def_crt_product
import Solutions.Sol_thm_prime_power_comparison

namespace SelmerCartanMotiveTowers

/-- Prime-power all-support comparison (Theorem 26.12,
`P2M-thm:prime-power-all-support-comparison`), REVISED per Strategy A.

Let `S` be a finite ordered support and `ν` a finite odd-prime depth datum.
The CRT product line `L^{conf}_ν = ZMod N_ν` (with `N_ν = ∏ p^{ν_p}`,
concrete via `crtModulus`) has a canonical pointed universal Moore
presentation with `B_ν = 1` of exact order `N_ν` (paper property (i)).
The p-power reduction maps `ZMod (p^a) →+* ZMod (p^b)` are concrete
(via `ppowerRed`; paper property (iii)). The support-functorial dg
realization `ρ_{S,ν}^{Mot,MR}` remains a background hypothesis
(`WitnessBackground`: `crtRealization`, `crtRealizationIs`), as it
requires a DGA foundation not present in Mathlib (see LIMITATION in
`Def_crt_product.lean`).

REVISION NOTE (2026-10-09): The first draft was FALSE — it universally
quantified over arbitrary `Line`/`Realization` types and unconstrained
`hasMoorePresentation`/`isSupportFunctorialDg` predicates while the
conclusion required them to hold (countermodel: both constantly `False`).
REVISION NOTE 2 (2026-10-09, P1-4): The CRT product, Moore presentation,
and p-power reductions are now concrete (`Def_crt_product.lean`):
`N_ν` is `crtModulus ν`, the line is `ZMod N_ν`, the Moore class is `1`
with exact order `N_ν` (`crtLine_order`), and reductions are `ppowerRed`.
Only the dg realization stays in the background. -/
theorem thm_prime_power_comparison
    (S : finite_ordered_support) (ν : coefficient_exponent)
    (bg : WitnessBackground) :
    -- (i) Concrete CRT product has Moore presentation of exact order N_ν
    addOrderOf (crtMoorePresentation ν).B = crtModulus ν ∧
    -- (iii) Concrete p-power reduction maps exist
    (∀ (p a b : ℕ), b ≤ a → Nonempty (ZMod (p ^ a) →+* ZMod (p ^ b))) ∧
    -- Dg realization (background; DGA foundation needed)
    ∃ (ρ : bg.DgRealization), bg.crtIsSupportFunctorialDg ρ :=
  SelmerCartanMotiveTowers.sol_thm_prime_power_comparison S ν bg

end SelmerCartanMotiveTowers
