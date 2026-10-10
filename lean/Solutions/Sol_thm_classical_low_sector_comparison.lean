import Definitions.Def_formal_background

namespace SelmerCartanMotiveTowers

/-- Solution for Theorem 27.5 (`thm_classical_low_sector_comparison`), M11.

P1-3 REVISION: The `FormalBackground` package §2 now records the shadow
functor into the CONCRETE target `ClassicalMooreCone` (the paper's
`Q_d = Cone(d : T → T)[-1]`), with concrete defining properties
(`bg.shadowZero : IsArtin`, `bg.shadowMoore : IsMoorePresentation`).
The proof is direct assembly; the target-side cone theory (order-reduction
`q_{d,d'}`, transitivity, `H¹ = ZMod d`) is proved in
`Def_classical_shadow_cone`, not assumed here. -/
theorem sol_thm_classical_low_sector_comparison (bg : FormalBackground) :
    ∃ shadow : bg.FramedSector → ClassicalMooreCone,
      (∀ X, bg.ZeroMotive X → IsArtin (shadow X)) ∧
      (∀ X, bg.MooreSeed X → IsMoorePresentation (shadow X)) :=
  ⟨bg.shadow, bg.shadowZero, bg.shadowMoore⟩

end SelmerCartanMotiveTowers
