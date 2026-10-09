import Definitions.Def_finite_ordered_support
import Mathlib.Data.Finset.Card

namespace SelmerCartanMotiveTowers

/-- An exact-support channel index for a finite ordered support `S`: a
subset `I ⊆ S` with `|I| ≥ 3` equipped with an ordered bipartition
`(A, B)` (disjoint, covering `I`). These index the geometric channels of
the motivic Moore–Reedy realization: every ordered bipartition monomial
in every higher latching polynomial gets a distinct channel (paper
§19, `P2M-thm:channel-complete-realization` (ii)). The type is defined
from `S`, not postulated; it is empty iff `S` has fewer than 3 primes,
which is the honest content. -/
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

end SelmerCartanMotiveTowers
