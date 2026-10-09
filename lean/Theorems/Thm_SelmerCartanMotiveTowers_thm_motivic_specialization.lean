import Definitions.Def_adic_witness
import Definitions.Def_motivic_moore_reedy
import Definitions.Def_pointed_cyclic_carrier
import Definitions.Def_witness_background
import Solutions.Sol_thm_motivic_specialization

namespace SelmerCartanMotiveTowers

/-- Carrier-level motivic specialization of the witness (Theorem 38.5,
`W31-thm:common-source-motivic-span`), REVISED per Strategy A and
strengthened per external-verifier P1-4.

Assuming the witness arithmetic background (`WitnessBackground` §5: the
three pointed cyclic order-31 carrier lines — the arithmetic line from
the `K*` branch's `κ₅^root` identification, the marked source line, and
the motivic Moore line in the `I_*`-block), relative to the fixed source
marking, the arithmetic realization and the motivic realization give a
pointed carrier span
`L_*^{ar} ←ρ_*^{ar} L_*^{src} →ρ_*^{Mot} L_*^{Mot}`
of cyclic order-31 lines: the two arrows are *real* additive
isomorphisms preserving the distinguished generators (constructed via
the canonical `ZMod 31` identification, the paper's "unique
generator-preserving identification"), not an opaque span predicate.
The right-hand line is the fixed Moore carrier in the `I_*`-block of
the finite marked Moore–Reedy package; the proper 31-fold arithmetic
Massey value is recorded as a marking on this fixed motivic carrier.

CARRIER-LEVEL ONLY. The independent operation-level provenance (the
unipotent central extension and obstruction-gerbe correspondence) is
Theorem 38.1 (`thm_gerbe_provenance`); the paper is explicit that "the
carrier identification alone does not turn arithmetic cochains into
motivic correspondences."

REVISION NOTE (2026-10-09): The first draft was FALSE — it universally
quantified over an arbitrary `CarrierLine` type and unconstrained
`isOrder31`/`carrierSpan` predicates while the conclusion required them to
hold (countermodel: both constantly `False`). The Strategy A revision
took the paper's carrier-line data as background.

REVISION NOTE 2 (2026-10-09, verifier P1-4): the opaque `CarrierLine`
type and `isOrder31`/`carrierSpan` predicates are replaced by concrete
`pointed_cyclic_carrier` structures (carrier + generator of exact
additive order 31). The span isomorphisms are now *proved* from the
carriers by pure algebra rather than projected from a background
predicate. -/
theorem thm_motivic_specialization
    (W : adic_witness) (M : motivic_moore_reedy) (bg : WitnessBackground) :
    ∃ (ρ_ar : bg.Lsrc.carrier ≃+ bg.Lar.carrier)
      (ρ_mot : bg.Lsrc.carrier ≃+ bg.LMot.carrier),
      ρ_ar bg.Lsrc.gen = bg.Lar.gen ∧ ρ_mot bg.Lsrc.gen = bg.LMot.gen :=
  SelmerCartanMotiveTowers.sol_thm_motivic_specialization W M bg

end SelmerCartanMotiveTowers
