import Mathlib.Algebra.Squarefree.Basic
import Definitions.Def_motivic_moore_reedy
import Definitions.Def_finite_ordered_support

namespace SelmerCartanMotiveTowers

/-- Reedy decomposition data for a jet tower (paper (ii), Thm 25.14).

At every jet level, the Moore–Reedy object splits as the proper-face
latching object plus the exact-support cofiber:
  `M_{I,N} ≅ L̂_I ⊕ Q_I`
with the differential relation `dγ_I = Nβ_I`, independently of the jet
level. The `saturation` field records the Boolean saturation.

LIMITATIONS: The full combinatorial definition of the proper-face
latching object (as a colimit over proper faces) and the Boolean
saturation construction need Reedy-categorical machinery not formalized
here. This structure records the *algebraic shadow* actually used in the
paper's proof: the splitting, the differential relation, and
level-independence. -/
structure ReedyDecomp (carrier : Type) [AddCommGroup carrier] (N : ℕ) where
  /-- The proper-face latching object. -/
  latchObj : Type
  [latchAdd : AddCommGroup latchObj]
  /-- Boolean saturation. -/
  saturation : Type
  [satAdd : AddCommGroup saturation]
  /-- The exact-support cofiber. -/
  cofiber : Type
  [cofAdd : AddCommGroup cofiber]
  /-- Reedy splitting: `M ≅ L̂ ⊕ Q` (paper (ii)). -/
  reedy_iso : carrier ≃+ latchObj × cofiber
  /-- The differential on the carrier. -/
  d : carrier →+ carrier
  /-- The γ class (`γ_I`). -/
  gamma : carrier
  /-- The β class (`β_I`). -/
  beta : carrier
  /-- `dγ_I = Nβ_I` (paper (ii)). -/
  d_gamma_eq : d gamma = N • beta

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

REVISION NOTE 3 (2026-10-10): Adds Reedy/face compatibility laws
(paper (i)(ii)(iii)):
- `delMap`/`del_succ_comm`: support deletion commutes with jet successor;
- `reedy : ReedyDecomp carrier N`: the Moore–Reedy splitting
  `M ≅ L̂ ⊕ Q` with `dγ = Nβ`, independent of jet level;
- `apex`/`history_apex_eq`: history realizations share the same terminal
  structural apex.

LIMITATIONS (P1-2): The bar-complex constancy (iv) and readout
commutation (v) need spectral/bicategorical machinery, not formalized
here. History pseudonaturality (iii, bicategorical part) is recorded as
the finite family; the 2-cell coherences are not formalized. The
combinatorial proper-face latching colimit and Boolean saturation
construction are background; `ReedyDecomp` records their algebraic
shadow. -/
structure jet_tower (S : finite_ordered_support) (N : ℕ) where
  /-- The shared carrier: no new carrier at any jet level (vi). -/
  carrier : Type
  [carrierNontrivial : Nontrivial carrier]
  [carrierAdd : AddCommGroup carrier]
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
  /-- (ii) Latching is independent of jet level: the proper-face latching
      object and Boolean saturation are those of the original Moore–Reedy
      reconstruction, "independently of the jet level" (paper (ii)). -/
  latch_level_indep : ∀ (n₁ n₂ : ℕ) (h₁ : 3 ≤ n₁) (h₂ : 3 ≤ n₂),
    latch n₁ h₁ = latch n₂ h₂
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
  /-- (i) Support–jet closure: support deletion on the carrier.
      Deleting the primes in `T` from the support. -/
  delMap : Finset ↥S.primes → carrier → carrier
  /-- (i) Support deletion commutes with the jet successor (latch):
      "support deletion and jet successor commute" (paper (i)). -/
  del_succ_comm : ∀ (T : Finset ↥S.primes) (n : ℕ) (h : 3 ≤ n) (x : carrier),
    delMap T (latch n h x) = latch n h (delMap T x)
  /-- (ii) Reedy decomposition: the Moore–Reedy splitting `M ≅ L̂ ⊕ Q`
      with `dγ = Nβ`, independent of the jet level (paper (ii)). -/
  reedy : ReedyDecomp carrier N
  /-- (iii) History closure: the terminal structural apex shared by all
      jet-level history realizations (paper (iii)). -/
  apex : motivic_moore_reedy
  /-- (iii) Every history's terminal entry is the apex. -/
  history_apex_eq : ∀ (n : ℕ) (h : 3 ≤ n),
    history n h ⟨n - 3, by omega⟩ = apex

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
