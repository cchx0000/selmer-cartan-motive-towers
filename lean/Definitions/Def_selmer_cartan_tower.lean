import Definitions.Def_full_mot
import Definitions.Def_rec_one_mot

namespace SelmerCartanMotiveTowers

/-- The two-level Selmer–Cartan tower: the recursive tier `SCart^rec` and the
full tier `SCart^full := SCart^rec ×_{Mot^{rec,1}} Mot^full` (the pullback over
`R_1` and `τ₁`), equipped with the realizations `R_full : SCart^full →
Mot^full` and `R_1 : SCart^rec → Mot^{rec,1}` forming the commutative
realization square `τ₁ ∘ R_full = R_1 ∘ proj`. The pullback universal property
is recorded (`pullback_univ`): every cone over the cospan factors uniquely
through the full tier. (Introduction, §1.) -/
structure selmer_cartan_tower where
  recTier : Type
  fullTier : Type
  projRec : fullTier → recTier
  realizFull : fullTier → full_mot
  realizOne : recTier → rec_one_mot
  square_comm : ∀ x, tau_one (realizFull x) = realizOne (projRec x)
  pullback_univ : ∀ (T : Type) (f : T → recTier) (g : T → full_mot),
    (∀ t, realizOne (f t) = tau_one (g t)) →
    ∃ u : T → fullTier, (∀ t, projRec (u t) = f t) ∧ (∀ t, realizFull (u t) = g t) ∧
      ∀ v : T → fullTier, (∀ t, projRec (v t) = f t) ∧ (∀ t, realizFull (v t) = g t) →
        v = u

end SelmerCartanMotiveTowers
