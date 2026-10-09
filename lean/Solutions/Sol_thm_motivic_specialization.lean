import Definitions.Def_adic_witness
import Definitions.Def_motivic_moore_reedy
import Definitions.Def_pointed_cyclic_carrier
import Definitions.Def_witness_background

namespace SelmerCartanMotiveTowers

/-- Solution for Theorem 38.5 (`thm_motivic_specialization`), M16.

The three carrier lines are `pointed_cyclic_carrier`s (background §5:
the arithmetic line from the `K*` branch, the marked source line, the
motivic Moore line). The pointed span
`L_*^{ar} ← L_*^{src} → L_*^{Mot}` is *constructed*, not assumed: any two
pointed cyclic order-31 carriers admit a canonical generator-preserving
isomorphism (`pointed_cyclic_carrier.canonicalIso`, via `ZMod 31`),
which is the paper's "unique generator-preserving identification".

CARRIER-LEVEL ONLY. The independent operation-level provenance
(unipotent central extension, obstruction gerbe) is Theorem 38.1
(`thm_gerbe_provenance`); the paper is explicit that "the carrier
identification alone does not turn arithmetic cochains into motivic
correspondences."

The witnesses `W` (adic witness) and `M` (motivic Moore–Reedy package)
are unused binders retained from the draft statement. -/
theorem sol_thm_motivic_specialization
    (W : adic_witness) (M : motivic_moore_reedy) (bg : WitnessBackground) :
    ∃ (ρ_ar : bg.Lsrc.carrier ≃+ bg.Lar.carrier)
      (ρ_mot : bg.Lsrc.carrier ≃+ bg.LMot.carrier),
      ρ_ar bg.Lsrc.gen = bg.Lar.gen ∧ ρ_mot bg.Lsrc.gen = bg.LMot.gen :=
  ⟨bg.Lsrc.canonicalIso bg.Lar, bg.Lsrc.canonicalIso bg.LMot,
    bg.Lsrc.canonicalIso_apply_gen bg.Lar,
    bg.Lsrc.canonicalIso_apply_gen bg.LMot⟩

end SelmerCartanMotiveTowers
