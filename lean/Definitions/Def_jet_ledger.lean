import Mathlib.Algebra.Squarefree.Basic
import Definitions.Def_motivic_moore_reedy
import Definitions.Def_finite_ordered_support

namespace SelmerCartanMotiveTowers

/-- An infinite jet tower for Theorem 25.14 (paper §38, P1-2 deepening).

For each jet level `n ≥ 3`, a Moore–Reedy object with support `S` and
coefficient order `N`, all sharing a single carrier and correspondence
algebra (paper (vi): no structural growth). The tower carries:
- (i) support–jet data: each level has support `S`, order `N`;
- (ii) Reedy/latching maps: jet successor `latch n : carrier → carrier`;
- (iii) history: at level `n`, the finite family of levels `3..n`;
- (vi) no-growth: one shared carrier/algebra for all levels.

The finite ledger for ceiling `M` is the restriction to `3 ≤ n ≤ M`;
cross-ceiling compatibility is by construction (same tower).

LIMITATIONS (P1-2): The bar-complex constancy (iv) and readout
commutation (v) need spectral/bicategorical machinery, not formalized
here. History pseudonaturality (iii, bicategorical part) is recorded as
the finite family; the 2-cell coherences are not formalized. -/
structure jet_tower (S : finite_ordered_support) (N : ℕ) where
  /-- The shared carrier: no new carrier at any jet level (vi). -/
  carrier : Type
  [carrierNontrivial : Nontrivial carrier]
  /-- The shared correspondence algebra. -/
  corrAlgebra : Type
  [algebraNontrivial : Nontrivial corrAlgebra]
  /-- The Moore–Reedy object at jet level `n ≥ 3`. -/
  atLevel : (n : ℕ) → 3 ≤ n → motivic_moore_reedy
  /-- (i) Support–jet closure: every level has support `S`. -/
  atLevel_support : ∀ (n : ℕ) (h : 3 ≤ n), (atLevel n h).support = S
  /-- (i) Every level has coefficient order `N`. -/
  atLevel_order : ∀ (n : ℕ) (h : 3 ≤ n), (atLevel n h).coeffOrder = N
  /-- (vi) No structural growth: every level shares the carrier. -/
  atLevel_carrier : ∀ (n : ℕ) (h : 3 ≤ n), (atLevel n h).carrier = carrier
  /-- Every level shares the correspondence algebra. -/
  atLevel_algebra : ∀ (n : ℕ) (h : 3 ≤ n), (atLevel n h).corrAlgebra = corrAlgebra
  /-- (ii) Reedy latching: jet successor map at level `n`. -/
  latch : (n : ℕ) → 3 ≤ n → carrier → carrier
  /-- (iii) History: at level `n`, the finite family of objects at
      levels `3, 4, ..., n` (indexed by `Fin (n - 2)`). -/
  history : (n : ℕ) → (h : 3 ≤ n) → Fin (n - 2) → motivic_moore_reedy
  /-- History agrees with the tower levels. -/
  history_eq : ∀ (n : ℕ) (h : 3 ≤ n) (k : Fin (n - 2)),
    history n h k = atLevel (k.val + 3) (by omega)
  /-- History entries have support `S`. -/
  history_support : ∀ (n : ℕ) (h : 3 ≤ n) (k : Fin (n - 2)),
    (history n h k).support = S
  /-- History entries have order `N`. -/
  history_order : ∀ (n : ℕ) (h : 3 ≤ n) (k : Fin (n - 2)),
    (history n h k).coeffOrder = N

namespace jet_tower

variable {S : finite_ordered_support} {N : ℕ}

/-- The finite ledger for ceiling `M`: restriction of the tower to
    `3 ≤ n ≤ M`, as a `Fin (M - 2)`-indexed family (level `k.val + 3`). -/
def ledger (T : jet_tower S N) (M : ℕ) (hM : 3 ≤ M) :
    Fin (M - 2) → motivic_moore_reedy :=
  fun k => T.atLevel (k.val + 3) (by omega)

/-- Cross-ceiling no-growth: the `M₁`-ledger is the restriction of the
    `M₂`-ledger (for `M₁ ≤ M₂`), because both come from the same tower. -/
theorem ledger_restrict (T : jet_tower S N) (M₁ M₂ : ℕ)
    (h1 : 3 ≤ M₁) (h2 : 3 ≤ M₂) (hle : M₁ ≤ M₂) (k : Fin (M₁ - 2)) :
    T.ledger M₁ h1 k =
      T.ledger M₂ h2 ⟨k.val, by omega⟩ := rfl

end jet_tower

end SelmerCartanMotiveTowers
