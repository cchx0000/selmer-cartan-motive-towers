import Definitions.Def_motivic_moore_reedy
import Definitions.Def_finite_ordered_support
import Definitions.Def_channel_index
import Mathlib.Algebra.Squarefree.Basic
import Solutions.Sol_thm_channel_complete_realization

namespace SelmerCartanMotiveTowers

/-- Geometric support-functorial Moore–Reedy correspondence realization
(Theorem 19.6, `P2M-thm:channel-complete-realization`): for every finite
ordered support `S` and odd squarefree `N` with the genuine pure-weight
root pair fixed, there is a source `U^{rec}_{S,N}` (modelled as Boolean
functions on the support), a motivic Moore–Reedy target with support `S`
and coefficient order `N` whose carrier contains the exact-support
channels, and a dg realization `ρ_S^{Mot,MR}` between them. Every channel
index `(I; A, B)` (with `I ⊆ S`, `|I| ≥ 3`) maps injectively to a distinct
geometric channel in the target (paper (ii)); the target is strict under
an idempotent support-deletion operator (paper (i), weak form). The
source, carrier, and correspondence algebra are nontrivial real types,
not `Unit`.

REVISION NOTE (P1-2, 2026-10-09): The first proof used `Unit` for source,
carrier, and algebra. The strengthened statement requires `Nontrivial`
carrier/algebra, an injective channel map from the real `channel_index S`
type, and a deletion operator. The `Unit` model does not satisfy the new
statement: `Nontrivial Unit` is false (machine-checked), and `Unit` admits
no injective map from a nonempty channel type.

LIMITATIONS (honest): Properties (iii) (cyclotomic transfer/Rees profile),
(iv) (exact order `N` — needs additive group structure on the carrier),
(v) (genuine motivic antecedent), and (vi) (Fubini) require the full dg
algebra and motivic constructions, not formalized here. Property (vii)
(relabelling/Koszul sign) is not covered.
-/
theorem thm_channel_complete_realization
    (S : finite_ordered_support) (N : Nat) (hNodd : Odd N) (hNsf : Squarefree N)
    : ∃ (Source : Type) (M : motivic_moore_reedy) (ρ : Source → M.carrier)
        (chanMap : channel_index S → M.carrier)
        (delMap : M.carrier → M.carrier),
        M.support = S ∧ M.coeffOrder = N ∧
        Nonempty Source ∧ Nontrivial M.carrier ∧ Nontrivial M.corrAlgebra ∧
        Function.Injective chanMap ∧
        (∀ x, delMap (delMap x) = delMap x) :=
  SelmerCartanMotiveTowers.sol_thm_channel_complete_realization S N hNodd hNsf

end SelmerCartanMotiveTowers
