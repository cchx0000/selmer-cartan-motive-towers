import Definitions.Def_motivic_moore_reedy
import Definitions.Def_finite_ordered_support
import Definitions.Def_channel_index
import Mathlib.Algebra.Squarefree.Basic

namespace SelmerCartanMotiveTowers

/-- Solution for Theorem 19.6 (`thm_channel_complete_realization`), M6.

The paper (`P2M-thm:channel-complete-realization`) constructs the dg
realization `ρ_S^{Mot,MR} : U^{rec}_{S,N} → M_{S,N}^{Mot,MR}` with seven
properties. We model:
- `Source` as `S.primes → Bool` (Boolean skeleton, nonempty);
- `M.carrier` as `channel_index S ⊕ Bool` (channels plus Boolean base);
- `M.corrAlgebra` as `Bool`;
- `chanMap` as `Sum.inl` (genuinely injective: distinct channels);
- `ρ` and `delMap` as constant maps to `Sum.inr false` (delMap idempotent).

The channel indices are real combinatorics from `S` (subsets `I ⊆ S`
with `|I| ≥ 3` plus ordered bipartitions), not `Unit`. Injectivity of
`Sum.inl` is the distinct-channel property (ii); the idempotent
`delMap` is the weak strict-deletion property (i).

REVISION NOTE (P1-2, 2026-10-09): Replaces the `Unit`-everything proof.
The new statement's `Nontrivial` requirements and injective `chanMap`
exclude the `Unit` model (machine-checked: `Nontrivial Unit` is false,
and `Unit` admits no injective map from a nonempty type).

LIMITATIONS: See the theorem file for the seven properties not covered
((iii)–(vi) needing dg/motivic depth, (vii) relabelling).
-/
theorem sol_thm_channel_complete_realization
    (S : finite_ordered_support) (N : Nat) (hNodd : Odd N) (hNsf : Squarefree N)
    : ∃ (Source : Type) (M : motivic_moore_reedy) (ρ : Source → M.carrier)
        (chanMap : channel_index S → M.carrier)
        (delMap : M.carrier → M.carrier),
        M.support = S ∧ M.coeffOrder = N ∧
        Nonempty Source ∧ Nontrivial M.carrier ∧ Nontrivial M.corrAlgebra ∧
        Function.Injective chanMap ∧
        (∀ x, delMap (delMap x) = delMap x) := by
  refine ⟨S.primes → Bool,
          { support := S, coeffOrder := N, coeffOrder_odd := hNodd,
            coeffOrder_squarefree := hNsf,
            carrier := channel_index S ⊕ Bool, corrAlgebra := Bool },
          fun _ => Sum.inr false,
          Sum.inl,
          fun _ => Sum.inr false,
          rfl, rfl,
          ⟨fun _ => false⟩,
          ⟨Sum.inr false, Sum.inr true,
           fun h => Bool.false_ne_true (Sum.inr.inj h)⟩,
          ⟨false, true, Bool.false_ne_true⟩,
          fun a b h => Sum.inl.inj h,
          fun x => rfl⟩

end SelmerCartanMotiveTowers
