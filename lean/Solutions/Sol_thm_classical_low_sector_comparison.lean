import Definitions.Def_formal_background

namespace SelmerCartanMotiveTowers

/-- Solution for Theorem 27.5 (`thm_classical_low_sector_comparison`), M11.

The `FormalBackground` package §2 records exactly the paper's specific
classical shadow functor (`bg.shadow`) together with its two defining
properties (`bg.shadowZero`, `bg.shadowMoore`); the proof is direct
assembly. -/
theorem sol_thm_classical_low_sector_comparison (bg : FormalBackground) :
    ∃ shadow : bg.FramedSector → bg.Classical,
      (∀ X, bg.ZeroMotive X → ∃ A, bg.ArtinObj A ∧ shadow X = A) ∧
      (∀ X, bg.MooreSeed X → ∃ B, bg.MultNPresentation B ∧ shadow X = B) :=
  ⟨bg.shadow, bg.shadowZero, bg.shadowMoore⟩

end SelmerCartanMotiveTowers
