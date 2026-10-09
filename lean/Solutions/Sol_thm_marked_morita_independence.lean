import Definitions.Def_formal_background

namespace SelmerCartanMotiveTowers

/-- Solution for Theorem 30.2 (`thm_marked_morita_independence`), M13.

The conclusion is verbatim the §4 fields of `FormalBackground`: the
representing exact-equivalence data and its induced tower bijections
(Toën derived Morita, CITED). Direct assembly. -/
theorem solution (bg : FormalBackground) :
    ∃ (eRec : bg.C.recTier → bg.C'.recTier) (eFull : bg.C.fullTier → bg.C'.fullTier),
      Function.Bijective eRec ∧ Function.Bijective eFull ∧
      (∀ x, bg.C'.projRec (eFull x) = eRec (bg.C.projRec x)) ∧
      (∀ x, bg.C'.realizFull (eFull x) = bg.C.realizFull x) ∧
      (∀ y, bg.C'.realizOne (eRec y) = bg.C.realizOne y) :=
  ⟨bg.eRec, bg.eFull, bg.eRecBijective, bg.eFullBijective,
    bg.eIntertwineProj, bg.eIntertwineFull, bg.eIntertwineOne⟩

end SelmerCartanMotiveTowers
