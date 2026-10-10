import Definitions.Def_finite_ordered_support
import Mathlib.Data.Finset.Card

namespace SelmerCartanMotiveTowers

/-- An exact-support channel index for a finite ordered support `S`: a
subset `I ⊆ S` with `|I| ≥ 3` equipped with an ordered bipartition
`(A, B)` (disjoint, covering `I`, **both nonempty**). These index the
geometric channels of the motivic Moore–Reedy realization: every ordered
bipartition monomial in every higher latching polynomial gets a distinct
channel (paper §19, `P2M-thm:channel-complete-realization` (ii)). The
nonemptiness of both sides is the paper's `𝔓^{→}(I)` definition
(L5893–5898): `{(A,B) : A ⊔ B = I, A,B ≠ ∅}`. The type is defined
from `S`, not postulated; it is empty iff `S` has fewer than 3 primes,
which is the honest content.

REVISION NOTE (P1-2 deep, 2026-10-09): Added `partA_nonempty` and
`partB_nonempty` per verifier feedback — the original allowed
`(∅, I)` / `(I, ∅)` which the paper excludes.

SCOPE NOTE (2026-10-10, verifier P1-2 M6 audit): distinct bipartitions
`(A,B) ≠ (B,A)` are distinct indices when `A ≠ B`. The production
realization's support-reading coordinate only reads `c.supp`, so it does
not distinguish same-support `(A,B)`/`(B,A)` — see the NOT ESTABLISHED
list in
`Thm_SelmerCartanMotiveTowers_thm_channel_complete_realization.lean`. -/
structure channel_index (S : finite_ordered_support) where
  supp : Finset ℕ
  supp_sub : supp ⊆ S.primes
  card_ge : 3 ≤ supp.card
  partA : Finset ℕ
  partB : Finset ℕ
  partA_sub : partA ⊆ supp
  partB_sub : partB ⊆ supp
  part_cover : partA ∪ partB = supp
  part_disjoint : Disjoint partA partB
  partA_nonempty : partA.Nonempty
  partB_nonempty : partB.Nonempty

/-- Decidable equality for channel indices. Two indices are equal iff
their data fields (`supp`, `partA`, `partB`) agree; the propositional
fields are proof-irrelevant. -/
instance (S : finite_ordered_support) : DecidableEq (channel_index S) := by
  intro a b
  have hiff : (a.supp = b.supp ∧ a.partA = b.partA ∧ a.partB = b.partB) ↔ (a = b) := by
    constructor
    · rintro ⟨h1, h2, h3⟩
      cases a with
      | mk supp1 _ _ partA1 partB1 _ _ _ _ _ _ =>
        cases b with
        | mk supp2 _ _ partA2 partB2 _ _ _ _ _ _ =>
          simp only at h1 h2 h3
          subst h1; subst h2; subst h3
          rfl
    · intro h
      subst h
      exact ⟨rfl, rfl, rfl⟩
  exact decidable_of_iff _ hiff

end SelmerCartanMotiveTowers
