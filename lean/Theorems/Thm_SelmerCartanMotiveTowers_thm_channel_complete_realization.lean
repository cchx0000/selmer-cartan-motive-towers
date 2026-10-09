import Definitions.Def_motivic_moore_reedy
import Definitions.Def_finite_ordered_support
import Definitions.Def_channel_index
import Mathlib.Algebra.Squarefree.Basic
import Solutions.Sol_thm_channel_complete_realization

namespace SelmerCartanMotiveTowers

/-- Geometric support-functorial Moore–Reedy correspondence realization
(Theorem 19.6, `P2M-thm:channel-complete-realization`): for every finite
ordered support `S` and odd squarefree `N > 1` with the genuine pure-weight
root pair fixed, there is a source `U^{rec}_{S,N}` (modelled as Boolean
functions on the support), a motivic Moore–Reedy target with support `S`
and coefficient order `N` whose carrier is `(channel_index S → ZMod N) × ℤ`
(functions from channels to `ZMod N`, plus an auxiliary `ℤ` for
nontriviality), and a dg realization `ρ_S^{Mot,MR}` between them.

- Every channel index `(I; A, B)` (with `I ⊆ S`, `|I| ≥ 3`, `A,B ≠ ∅`)
  maps via `chanMap` (Dirac delta) injectively to a distinct geometric
  channel (paper (ii)); each has exact additive order `N` (paper (iv)).
- The realization `ρ` is built from the channel support data
  (`c.supp ⊆ filter f`), not a constant map.
- The correspondence algebra is `ZMod N` (a real ring, not `Bool`).
- The target is strict under an idempotent support-deletion operator
  (paper (i), weak form).

REVISION NOTE (P1-2 deep, 2026-10-09): Addresses verifier feedback.
`channel_index` now requires `A,B ≠ ∅` (paper L5893–5898). The carrier
has a real `AddCommGroup` structure; `chanMap` is the Dirac delta
(injective, order `N` — property (iv)). `ρ` uses channel support data.
`corrAlgebra` is `ZMod N`. The `Unit`/`Bool`-carrier model does not
satisfy the new statement.

LIMITATIONS (honest): Properties (iii) (cyclotomic transfer/Rees profile),
(v) (genuine motivic antecedent), (vi) (Fubini), (vii) (relabelling/Koszul)
require the full dg algebra and motivic constructions. The dg controller
structure is not formalized; the additive structure for (ii)/(iv) is.
-/
theorem thm_channel_complete_realization
    (S : finite_ordered_support) (N : Nat) (hNodd : Odd N) (hNsf : Squarefree N)
    (hN1 : 1 < N)
    : ∃ (Source : Type) (M : motivic_moore_reedy) (hAdd : AddCommGroup M.carrier)
        (ρ : Source → M.carrier)
        (chanMap : channel_index S → M.carrier)
        (delMap : M.carrier → M.carrier),
        M.support = S ∧ M.coeffOrder = N ∧
        Nonempty Source ∧ Nontrivial M.carrier ∧ Nontrivial M.corrAlgebra ∧
        Function.Injective chanMap ∧
        (∀ c : channel_index S, @addOrderOf M.carrier hAdd.toAddMonoid (chanMap c) = N) ∧
        (∀ x, delMap (delMap x) = delMap x) :=
  SelmerCartanMotiveTowers.sol_thm_channel_complete_realization S N hNodd hNsf hN1

end SelmerCartanMotiveTowers
