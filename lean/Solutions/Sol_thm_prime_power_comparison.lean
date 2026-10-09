import Definitions.Def_finite_ordered_support
import Definitions.Def_typed_coordinates
import Definitions.Def_witness_background

namespace SelmerCartanMotiveTowers

/-- Solution for Theorem 26.12 (`thm_prime_power_comparison`), M10.

The witness arithmetic background package `WitnessBackground` supplies the
CRT product line with its Moore presentation (`crtLine`, `crtLineHas`) and
the dg realization (`crtRealization`, `crtRealizationIs`) as structure
fields — these record the paper's construction from the imported branch
inputs (I1)–(I4). The proof is direct assembly. -/
theorem sol_thm_prime_power_comparison
    (S : finite_ordered_support) (ν : coefficient_exponent)
    (bg : WitnessBackground) :
    ∃ (L : bg.CRTLine) (ρ : bg.DgRealization),
      bg.crtHasMoorePresentation L ∧ bg.crtIsSupportFunctorialDg ρ :=
  ⟨bg.crtLine, bg.crtRealization, bg.crtLineHas, bg.crtRealizationIs⟩

end SelmerCartanMotiveTowers
