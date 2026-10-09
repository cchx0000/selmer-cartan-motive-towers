import Definitions.Def_moore_cohomology_line
import Solutions.Sol_thm_formal_filtered_alignment

namespace SelmerCartanMotiveTowers

/-- Formal/filtered alignment at depth two (Theorem 8.21,
`P1C-thm:formal-filtered-alignment`), strengthened per external-verifier
P1-4: the universal exact-order Moore line and the primitive filtered
confluence line — now concrete (`ZMod (p*q^2)` and `ZMod p × ZMod (q^2)`,
see `Def_moore_cohomology_line.lean`) — admit a unique pointed `AddEquiv`
sending `[B_{2,1}]` to `(b_p, κ̃ mod q²)`. Under q-primary reduction it
sends the universal Moore generator to the residual secondary generator
`κ̄` (paper L2235–2260). -/
theorem thm_formal_filtered_alignment
    (p q : ℕ) (hp : p.Prime) (hq : q.Prime) (hpq : p ≠ q) :
    ∃! e : moore_line p q ≃+ conf_line p q,
      e (mooreGen p q) = confGen p q ∧
      qPrimaryRed p q (e (mooreGen p q)) = residualGen q :=
  SelmerCartanMotiveTowers.sol_thm_formal_filtered_alignment p q hp hq hpq

end SelmerCartanMotiveTowers
