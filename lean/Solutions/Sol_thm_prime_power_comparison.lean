import Definitions.Def_finite_ordered_support
import Definitions.Def_typed_coordinates
import Definitions.Def_witness_background
import Definitions.Def_crt_product

namespace SelmerCartanMotiveTowers

/-- Solution for Theorem 26.12 (`thm_prime_power_comparison`), M10.

P1-4 revision: The CRT product is now concrete.
- `N_ν = crtModulus ν` (the product of prime powers).
- The Moore presentation is `crtMoorePresentation ν` with `B_ν = 1`;
  its exact order `N_ν` is `crtLine_order ν` (via `ZMod.addOrderOf_one`).
- The p-power reductions are the concrete `ppowerRed` maps.
- The dg realization is still from the background (`bg.crtRealization`),
  as it requires a DGA foundation (see LIMITATION in `Def_crt_product`).

REVISION NOTE 2 (2026-10-09, P1-4): Rewritten from background-projection
to concrete CRT construction. -/
theorem sol_thm_prime_power_comparison
    (S : finite_ordered_support) (ν : coefficient_exponent)
    (bg : WitnessBackground) :
    addOrderOf (crtMoorePresentation ν).B = crtModulus ν ∧
    (∀ (p a b : ℕ), b ≤ a → Nonempty (ZMod (p ^ a) →+* ZMod (p ^ b))) ∧
    ∃ (ρ : bg.DgRealization), bg.crtIsSupportFunctorialDg ρ :=
  ⟨crtMoorePresentation ν |>.hB,
   fun p a b h => ⟨ppowerRed h⟩,
   bg.crtRealization, bg.crtRealizationIs⟩

end SelmerCartanMotiveTowers
