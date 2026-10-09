import Definitions.Def_motivic_background

namespace SelmerCartanMotiveTowers

/-- Solution for Theorem 12.2 (`thm_motivic_seed`), M5.

The motivic background package `MotivicBackground` supplies the root Moore
pair `(b_mot, c_mot)` with all required properties as structure fields,
including the cohomology-level exact order `hb_class_order`; the proof is
direct assembly.

REVISION NOTE 4 (2026-10-09, verifier P0-2): the cochain-level `N • b = 0`
and exactness conjuncts are REMOVED from the conclusion. The old fields
`hb_order`/`hb_exact` forced `d c_mot = 0` (via `hc_boundary`), collapsing
the integral Moore model whose differential is `×N`. The `N`-torsion now
lives only at cohomology level (`addOrderOf [b] = N`). -/
theorem sol_thm_motivic_seed (bg : MotivicBackground) :
    ∃ (b c : bg.Cochain),
      bg.d b = 0 ∧ bg.d c = bg.N • b ∧
      addOrderOf (bg.classOf b) = bg.N ∧
      bg.isGenuine c :=
  ⟨bg.b_mot, bg.c_mot, bg.hb_closed, bg.hc_boundary,
    bg.hb_class_order, bg.hc_genuine⟩

end SelmerCartanMotiveTowers
