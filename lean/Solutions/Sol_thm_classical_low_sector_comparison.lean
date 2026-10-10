import Definitions.Def_formal_background

namespace SelmerCartanMotiveTowers

/-- Solution for Theorem 27.5 (`thm_classical_low_sector_comparison`), M11.

P1-3 REVISION: The `FormalBackground` package §2 now records the shadow
functor into the CONCRETE target `ClassicalMooreCone` (the paper's
`Q_d = Cone(d : T → T)[-1]`), with concrete defining properties
(`bg.shadowZero : IsArtin`, `bg.shadowMoore : IsMoorePresentation`).
The proof is direct assembly; the target-side cone theory (order-reduction
`q_{d,d'}`, transitivity, `H¹ = ZMod d`) is proved in
`Def_classical_shadow_cone`, not assumed here.

CAVEAT (2026-10-10, verifier M11 audit): the proof below is direct
assembly of background fields — the SUBSTANCE (the shadow's existence and
its two defining properties) is assumed via the background, not proved.
In particular `bg.shadow` is an object function, not a functor;
homotopy-coherent functoriality, the actual cone `H¹` identification, and
the paper's coefficient `N` binding are not formalized.  See the theorem
file for the full gap list. -/
theorem sol_thm_classical_low_sector_comparison (bg : FormalBackground) :
    ∃ shadow : bg.FramedSector → ClassicalMooreCone,
      (∀ X, bg.ZeroMotive X → IsArtin (shadow X)) ∧
      (∀ X, bg.MooreSeed X → IsMoorePresentation (shadow X)) :=
  ⟨bg.shadow, bg.shadowZero, bg.shadowMoore⟩

end SelmerCartanMotiveTowers
