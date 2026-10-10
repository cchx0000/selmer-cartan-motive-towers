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
- The **finite CRT product isomorphism**
  `ZMod N_ν ≃+* Π_{p ∈ supp ν} ZMod (p^{ν_p})` is `crtProductEquiv ν`
  (via Mathlib's `ZMod.prodEquivPi`); it is pointed (`1 ↦ 1`,
  `crtProductEquiv_one`), and each component is the actual p-primary
  reduction (the generator/coefficient exchange diagram
  `crtProductEquiv_apply`).
- The p-power reductions are the concrete `ppowerRed` maps, with the
  composition law `red_{c≤b} ∘ red_{b≤a} = red_{c≤a}` (`ppowerRed_comp`),
  replacing the earlier bare `Nonempty` statement.
- The dg realization is still from the background (`bg.crtRealization`),
  as it requires a DGA foundation (see LIMITATION in `Def_crt_product`).
- The integral 2-term complex `ℤ C_ν →[N_ν] ℤ B_ν` (integral `C`,
  differential, quotient identification) is honestly labeled as not
  constructed (see LIMITATION in `Def_crt_product`).

REVISION NOTE 2 (2026-10-09, P1-4): Rewritten from background-projection
to concrete CRT construction.
REVISION NOTE 3 (2026-10-10, P1-4): Full finite CRT product isomorphism
added (`crtProductEquiv`, pointed, with exchange diagram); reduction
maps now come with their composition law instead of bare `Nonempty`. -/
theorem sol_thm_prime_power_comparison
    (S : finite_ordered_support) (ν : coefficient_exponent)
    (bg : WitnessBackground) :
    addOrderOf (crtMoorePresentation ν).B = crtModulus ν ∧
    (∃ e : ZMod (crtModulus ν) ≃+*
        Π p : ↥(ν.val.support), ZMod (p.val.val ^ ν.val p.val),
      e 1 = 1 ∧
      ∀ (p : ↥(ν.val.support)) (x : ZMod (crtModulus ν)),
        e x p = ZMod.castHom
          (Finset.dvd_prod_of_mem (fun q => q.val ^ ν.val q) p.property)
          (ZMod (p.val.val ^ ν.val p.val)) x) ∧
    (∀ (p a b c : ℕ) (h₁ : b ≤ a) (h₂ : c ≤ b),
      (ppowerRed (p := p) h₂).comp (ppowerRed (p := p) h₁)
        = ppowerRed (p := p) (h₂.trans h₁)) ∧
    ∃ (ρ : bg.DgRealization), bg.crtIsSupportFunctorialDg ρ :=
  ⟨crtMoorePresentation ν |>.hB,
   ⟨crtProductEquiv ν, crtProductEquiv_one ν,
    fun p x => crtProductEquiv_apply ν p x⟩,
   fun _p _a _b _c h₁ h₂ => ppowerRed_comp h₁ h₂,
   bg.crtRealization, bg.crtRealizationIs⟩

end SelmerCartanMotiveTowers
