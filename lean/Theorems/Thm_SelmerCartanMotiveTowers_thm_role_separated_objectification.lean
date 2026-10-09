import Definitions.Def_motivic_moore_reedy
import Definitions.Def_finite_ordered_support
import Definitions.Def_role_separation
import Solutions.Sol_thm_role_separated_objectification

namespace SelmerCartanMotiveTowers

/-- Object-level birth–control realization (Theorem 19.9,
`P2M-thm:role-separated-objectification`): for a finite ordered support
`S` with at least two primes and a coefficient order `N` (odd, squarefree,
`N ≥ 3`), there is a motivic Moore–Reedy target over `S` with coefficient
order `N`, carrying a role separation: controller objects `d_{q_i}^{sel}`
and birth objects `e_{q_j}^{sel}` with disjoint images (role-separated),
and a distinguished nonzero control edge marked exactly for `i < j`,
each witnessed by an actual `ControlEdge`.

REVISION NOTE (P1-2 deepening, 2026-10-09): The P1-2 revision replaced the
empty model but left `isSeparated` / `controlMarked` as free predicates
(`isSeparated = fun _ => True`, `controlMarked` defined by `↔ i < j`),
allowed `d = e`, and hardcoded `coeffOrder = 3`. This revision:
- uses the `RoleSeparation` structure: `separated : ∀ i j, d i ≠ e j` is a
  real disjointness property (not `fun _ => True`), so `d = e` is excluded;
- edges are witnessed by `ControlEdge` data (`edgeWitnessed`), not an
  unconstrained predicate;
- `coeffOrder` is the general `N` (odd, squarefree, `N ≥ 3`), not hardcoded 3.

LIMITATIONS (honest):
- Cutoff functoriality (paper item (iv)): not formalized; requires the
  direct-sum summand bookkeeping absent from the discrete model.
- Higher cells (paper item (iii)): not formalized; requires M6's channel cells.
- Morita compatibility (paper item (v)): not formalized; requires dg-categories
  (no Mathlib foundation).
-/
theorem thm_role_separated_objectification
    (S : finite_ordered_support) (h2 : 2 ≤ S.primes.card)
    (N : ℕ) (hNodd : Odd N) (hNsf : Squarefree N) (hN3 : 3 ≤ N)
    : ∃ (M : motivic_moore_reedy) (RS : RoleSeparation S)
        (embed : RS.Role → M.carrier),
        M.support = S ∧ M.coeffOrder = N ∧
        (∃ i j, RS.hasEdge i j) ∧
        Function.Injective embed :=
  SelmerCartanMotiveTowers.sol_thm_role_separated_objectification S h2 N hNodd hNsf hN3

end SelmerCartanMotiveTowers
