import Definitions.Def_motivic_moore_reedy
import Definitions.Def_finite_ordered_support
import Definitions.Def_role_separation
import Solutions.Sol_thm_role_separated_objectification

namespace SelmerCartanMotiveTowers

/-- Object-level birth–control realization (Theorem 19.9,
`P2M-thm:role-separated-objectification`): for a finite ordered support
`S` with at least two primes and a coefficient order `N` (odd, squarefree,
`N ≥ 3`), there is a motivic Moore–Reedy target over `S` with coefficient
order `N`, carrying a role separation: injective controller objects
`d_{q_i}^{sel}` and birth objects `e_{q_j}^{sel}` with disjoint images
(role-separated), and a distinguished nonzero control edge marked exactly
for `i < j`, each witnessed by an actual `HomElem` whose evaluation is
`proj_{ij} ∘ U_i` — the objectwise evaluation of the genuine Boolean
correspondence (paper item (ii)).

REVISION NOTE (P1-2 deepening, 2026-10-09): The P1-2 revision replaced the
empty model but left `isSeparated` / `controlMarked` as free predicates
(`isSeparated = fun _ => True`, `controlMarked` defined by `↔ i < j`),
allowed `d = e`, and hardcoded `coeffOrder = 3`. This revision:
- uses the `RoleSeparation` structure: `separated : ∀ i j, d i ≠ e j` is a
  real disjointness property (not `fun _ => True`), so `d = e` is excluded;
- edges are witnessed by `HomElem` data (`edgeWitnessed`), not an
  unconstrained predicate;
- `coeffOrder` is the general `N` (odd, squarefree, `N ≥ 3`), not hardcoded 3.

REVISION NOTE (M7 strengthening, 2026-10-10): The conclusion now explicitly
requires `Nontrivial M.carrier`, `Nontrivial M.corrAlgebra`, and the
separation property `∀ i j, RS.d i ≠ RS.e j` (the `RoleSeparation.separated`
field, surfaced at the statement level), matching the non-degeneracy
properties of the M6 target (Theorem 19.6). The constructed `M` is thus a
valid channel-complete-realization target shape.

REVISION NOTE (M7 model replacement, 2026-10-11): `RoleSeparation` now
takes the coefficient order `N` (roles live in `O_{S,N}^{sel}`); `Role`
carries a real `AddCommGroup` law (the old formal `Add` was left-projection
with no group laws); both families are injective (`dInjective` /
`eInjective`), excluding the degenerate constant-family model; the
endpoint-only `ControlEdge` is replaced by per-`(src, tgt)` `HomElem`s with
real `degree : ℕ` (= 0) and a real `closed` equation; new fields `U`
(Boolean idempotent correspondences), `proj` (summand projections),
`edgeWitnessed` with `eval = proj_{ij} ∘ U_i` (paper item (ii)), and
`summand_nonzero` (the `(i,j)`-summand is nonzero). This retries the staged
2026-10-10 rewrite, which failed to build on a missing `ZMod` import.

LIMITATIONS (honest):
- Cutoff functoriality (paper item (iv)): not formalized; requires the
  direct-sum summand bookkeeping absent from the discrete model.
- Higher cells (paper item (iii)): not formalized; requires M6's channel cells.
- Morita compatibility (paper item (v)): not formalized; requires dg-categories
  (no Mathlib foundation).
- The discrete differential `homDiff` is the zero operator (a model
  artifact): `closed` is the honest equation `homDiff eval = 0`, but it is
  automatic in the discrete model. There is no dg Hom-complex.
- The dg-level geometric content of `U_{q_i}` (composites of identities on
  shifted summands, zero-section/Gysin correspondences, graph
  correspondences) remains background. Formalized is the objectwise
  evaluation shape: additivity, Boolean idempotence, and the edge binding
  `eval = proj_{ij} ∘ U_i`.
-/
theorem thm_role_separated_objectification
    (S : finite_ordered_support) (h2 : 2 ≤ S.primes.card)
    (N : ℕ) (hNodd : Odd N) (hNsf : Squarefree N) (hN3 : 3 ≤ N)
    : ∃ (M : motivic_moore_reedy) (RS : RoleSeparation S N)
        (embed : RS.Role → M.carrier),
        M.support = S ∧ M.coeffOrder = N ∧
        Nontrivial M.carrier ∧ Nontrivial M.corrAlgebra ∧
        (∀ i j, RS.d i ≠ RS.e j) ∧
        (∃ i j, RS.hasEdge i j) ∧
        Function.Injective embed :=
  SelmerCartanMotiveTowers.sol_thm_role_separated_objectification S h2 N hNodd hNsf hN3

end SelmerCartanMotiveTowers
