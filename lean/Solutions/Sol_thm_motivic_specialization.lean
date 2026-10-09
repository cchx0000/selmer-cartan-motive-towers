import Definitions.Def_adic_witness
import Definitions.Def_motivic_moore_reedy
import Definitions.Def_witness_background

namespace SelmerCartanMotiveTowers

/-- Solution for Theorem 38.5 (`thm_motivic_specialization`), M16.

Strategy A direct assembly: `WitnessBackground` §5 carries exactly the
data the conclusion asks for — the three order-31 cyclic carrier lines
`Lar`, `Lsrc`, `LMot`, their `isOrder31` properties, and the pointed span
`hSpan`. The witnesses `W` (the adic witness) and `M` (the motivic
Moore–Reedy package) are unused binders retained from the draft statement;
the span data is recorded in the background package, which is where the
paper's §38 carrier-span construction is axiomatized. -/
theorem sol_thm_motivic_specialization
    (W : adic_witness) (M : motivic_moore_reedy) (bg : WitnessBackground) :
    ∃ (Lar : bg.CarrierLine) (Lsrc : bg.CarrierLine) (LMot : bg.CarrierLine),
      bg.isOrder31 Lar ∧ bg.isOrder31 Lsrc ∧ bg.isOrder31 LMot ∧
      bg.carrierSpan Lar Lsrc LMot :=
  ⟨bg.Lar, bg.Lsrc, bg.LMot, bg.hLar, bg.hLsrc, bg.hLMot, bg.hSpan⟩

end SelmerCartanMotiveTowers
