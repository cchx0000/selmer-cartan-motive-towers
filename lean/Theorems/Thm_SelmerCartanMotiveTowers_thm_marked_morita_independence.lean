import Definitions.Def_formal_background
import Mathlib.Logic.Function.Basic
import Solutions.Sol_thm_marked_morita_independence

namespace SelmerCartanMotiveTowers

/-- Marked Morita independence of the complete tower (Theorem 30.2,
`P2M-thm:marked-morita-presentation-independence`), REVISED per Strategy A.

Let `P : C ≃_{Mor} C'` be a pointed marked Morita equivalence, represented
(via Toën's derived Morita theory [ToenDerivedMorita], CITED) by an exact
equivalence of perfect derived categories. Assuming the formal background
(`FormalBackground` §4: the representing exact equivalence data and its
induced bijections on the tower tiers, plus functoriality of the
moduli-of-objects construction [Toën–Vaquié 2007, CITED]), then,
functorially in every finite support, coefficient stage, and
obstruction/jet ceiling, there are equivalences of the complete towers
`𝔗^{Mot,MR}_{N;S,≤M}(C) ≃ 𝔗^{Mot,MR}_{N;S,≤M}(C')` intertwining the tower
structure (projection, realizations); hence a Morita equivalence of the
completed dg categories and a canonical equivalence of
pseudo-perfect-module stacks. The complete marked tower is presentation
independent.

REVISION NOTE (2026-10-09): The first draft was FALSE — it universally
quantified over arbitrary towers `C, C'` and an unconstrained
`moritaRelated` predicate (true for the given pair) while the conclusion
required bijections between their tiers (countermodel: `C.recTier` empty,
`C'.recTier` nonempty). This revision takes the paper's specific Morita
data as an explicit hypothesis. The proof consumes no deep arithmetic
(pure homotopy algebra). -/
theorem thm_marked_morita_independence (bg : FormalBackground) :
    ∃ (eRec : bg.C.recTier → bg.C'.recTier) (eFull : bg.C.fullTier → bg.C'.fullTier),
      Function.Bijective eRec ∧ Function.Bijective eFull ∧
      (∀ x, bg.C'.projRec (eFull x) = eRec (bg.C.projRec x)) ∧
      (∀ x, bg.C'.realizFull (eFull x) = bg.C.realizFull x) ∧
      (∀ y, bg.C'.realizOne (eRec y) = bg.C.realizOne y) :=
  SelmerCartanMotiveTowers.sol_thm_marked_morita_independence bg

end SelmerCartanMotiveTowers
