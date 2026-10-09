import Definitions.Def_motivic_background

namespace SelmerCartanMotiveTowers

/-- Solution for Theorem 12.2 (`thm_motivic_seed`), M5.

The motivic background package `MotivicBackground` supplies the root Moore
pair `(b_mot, c_mot)` with all required properties as structure fields,
including the cohomology-level exact order `hb_class_order`; the proof is
direct assembly. -/
theorem sol_thm_motivic_seed (bg : MotivicBackground) :
    ∃ (b c : bg.Cochain),
      bg.d b = 0 ∧ bg.d c = bg.N • b ∧
      bg.N • b = 0 ∧ (∀ k : Nat, 0 < k → k < bg.N → k • b ≠ 0) ∧
      addOrderOf (bg.classOf b) = bg.N ∧
      bg.isGenuine c :=
  ⟨bg.b_mot, bg.c_mot, bg.hb_closed, bg.hc_boundary, bg.hb_order, bg.hb_exact,
    bg.hb_class_order, bg.hc_genuine⟩

end SelmerCartanMotiveTowers
