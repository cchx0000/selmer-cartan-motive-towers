import Definitions.Def_adic_witness
import Definitions.Def_motivic_moore_reedy
import Definitions.Def_witness_background
import Solutions.Sol_thm_motivic_specialization

namespace SelmerCartanMotiveTowers

/-- Carrier-level motivic specialization of the witness (Theorem 38.5,
`W31-thm:common-source-motivic-span`), REVISED per Strategy A.

Assuming the witness arithmetic background (`WitnessBackground` §5: the
order-31 cyclic carrier lines — the arithmetic carrier from the `K*`
branch's `κ₅^root` identification and the motivic Moore carrier in the
`I_*`-block — and their pointed span), relative to the fixed source
marking, the arithmetic realization and the motivic realization give a
pointed carrier span `L_*^{ar} ← L_*^{src} → L_*^{Mot}` of cyclic
order-31 lines, the right-hand line being the fixed Moore carrier in the
`I_*`-block of the finite marked Moore–Reedy package; the proper 31-fold
arithmetic Massey value is recorded as a marking on this fixed motivic
carrier.

REVISION NOTE (2026-10-09): The first draft was FALSE — it universally
quantified over an arbitrary `CarrierLine` type and unconstrained
`isOrder31`/`carrierSpan` predicates while the conclusion required them to
hold (countermodel: both constantly `False`; the read-back noted the
conclusion could be "discharged trivially" only because the predicates were
unconstrained — but as a universal claim it is false). This revision takes
the paper's specific carrier-line data as an explicit hypothesis. -/
theorem thm_motivic_specialization
    (W : adic_witness) (M : motivic_moore_reedy) (bg : WitnessBackground) :
    ∃ (Lar : bg.CarrierLine) (Lsrc : bg.CarrierLine) (LMot : bg.CarrierLine),
      bg.isOrder31 Lar ∧ bg.isOrder31 Lsrc ∧ bg.isOrder31 LMot ∧
      bg.carrierSpan Lar Lsrc LMot :=
  SelmerCartanMotiveTowers.sol_thm_motivic_specialization W M bg

end SelmerCartanMotiveTowers
