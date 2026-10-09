import Definitions.Def_full_mot

namespace SelmerCartanMotiveTowers

/-- The recursive 1-motivic target `Mot^{rec,1}`, as an opaque object type:
the recursive finite-support organization of the classical 1-motivic derived
target `D_1(k; Λ)`, the bounded derived category of Deligne 1-motives with
`Λ = Z[1/p]` over a perfect field `k` of exponential characteristic `p`.
(Definition 27.1.) -/
opaque rec_one_mot : Type

/-- The truncation `τ₁ : Mot^full → Mot^{rec,1}`, separating valuation depth
from support. Introduced as an axiom: it is background data of the theory,
not a construction. (Introduction, §1.) -/
axiom tau_one : full_mot → rec_one_mot

/-- Auxiliary depth-fiber projections: the valuation vector `(v_p(n))_p` on
the full side and its 0/1 indicator collapse on the recursive side. These are
formalization devices for stating the depth-fiber behavior displayed with the
tower; the paper does not name them as maps. (Architecture §1.) -/
axiom depth_of_full : full_mot → (Nat → Nat)
axiom depth_of_rec : rec_one_mot → (Nat → Nat)

/-- `τ₁` acts on depth fibers by collapsing valuations to support indicators:
`(v_p(n))_p ↦ (1_{v_p(n)>0})_p`. This formula is part of the defining display
of the organizing tower. (Architecture §1.) -/
axiom tau_one_depth_fiber : ∀ (m : full_mot) (p : Nat),
  depth_of_rec (tau_one m) p = if depth_of_full m p > 0 then 1 else 0

end SelmerCartanMotiveTowers
