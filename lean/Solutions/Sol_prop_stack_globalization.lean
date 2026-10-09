import Definitions.Def_formal_background

namespace SelmerCartanMotiveTowers

/-- Solution for Proposition 13.5 (`prop_stack_globalization`), M12.

The formal background package `FormalBackground` carries, in §3, exactly the
paper's definitional setup: `stackIsDerived` asserts that the moduli of
pseudo-perfect modules over the dg category from the fixed presentation is
the associated derived stack. The proposition's conclusion is that field
verbatim, so the proof is direct projection. -/
theorem solution (bg : FormalBackground) :
    ∀ G : bg.DGCategory, ∃ D : bg.moduliStack G, bg.isDerivedStack G D :=
  bg.stackIsDerived

end SelmerCartanMotiveTowers
