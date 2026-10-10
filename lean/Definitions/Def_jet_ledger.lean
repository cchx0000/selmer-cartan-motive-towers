import Mathlib.Algebra.Squarefree.Basic
import Mathlib.Data.Finset.Basic
import Mathlib.GroupTheory.OrderOfElement
import Definitions.Def_motivic_moore_reedy
import Definitions.Def_finite_ordered_support

namespace SelmerCartanMotiveTowers

/-- Reedy decomposition data for a jet tower (paper (ii), Thm 25.14).

At every jet level, the Moore–Reedy object splits as the proper-face
latching object plus the exact-support cofiber:
  `M_{I,N} ≅ L̂_I ⊕ Q_I`
with the differential relation `dγ_I = Nβ_I`, independently of the jet
level. The `saturation` field records the Boolean saturation.

REVISION NOTE 4 (2026-10-10): the algebraic shadow is deepened with
machine-checked content (previously all missing, see the verifier's
M8 todo item):
- `d_sq_zero`: the differential is square-zero (`d² = 0`);
- `grade`/`d_degree`: an ℕ-grading (homological degree) on the carrier,
  with `d` raising degree by 1 wherever it is nonzero;
- `beta_order`: the Moore class `β` has *exact* additive order `N`
  (paper (ii)/(iv): `ord[...] = N`), ruling out the degenerate zero
  Moore pair that also satisfies `dγ = Nβ`;
- `satMap`/`satMap_disjoint_union`: the Boolean saturation now comes
  with its associated lattice map `Finset ↥S.primes → saturation`,
  additive on disjoint Boolean unions — the algebraic content of the
  Boolean saturation (subsets of the support's primes map into the
  saturation carrier respecting the Boolean algebra structure).

LIMITATIONS: The full combinatorial definition of the proper-face
latching object (as a colimit over proper faces) needs Reedy-categorical
machinery not formalized here. This structure records the algebraic
shadow actually used in the paper's proof: the splitting, the
differential (with `d² = 0` and grading), the exact-order Moore pair,
and the Boolean saturation map, all independent of the jet level. -/
structure ReedyDecomp (S : finite_ordered_support) (carrier : Type) (N : ℕ) where
  /-- The carrier's additive group structure (as a field, so that
      `T.reedy.…` projections for a bound tower `T` need no
      typeclass synthesis). -/
  [carrierAdd : AddCommGroup carrier]
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
  /-- The differential is square-zero: `d² = 0` (paper (ii)). -/
  d_sq_zero : ∀ x, d (d x) = 0
  /-- ℕ-grading (homological degree) on the carrier. -/
  grade : carrier → ℕ
  /-- `d` raises degree by 1 wherever it is nonzero (paper (ii)). -/
  d_degree : ∀ x, d x ≠ 0 → grade (d x) = grade x + 1
  /-- The γ class (`γ_I`). -/
  gamma : carrier
  /-- The β class (`β_I`). -/
  beta : carrier
  /-- `dγ_I = Nβ_I` (paper (ii)). -/
  d_gamma_eq : d gamma = N • beta
  /-- `β` has exact additive order `N` (paper (ii)/(iv): `ord[...] = N`).
      This rules out the degenerate zero Moore pair. -/
  beta_order : addOrderOf beta = N
  /-- Boolean saturation map: subsets of the support's primes land in
      the saturation carrier (paper (ii)). -/
  satMap : Finset ↥S.primes → saturation
  /-- The saturation map respects the Boolean algebra: it is additive
      on disjoint unions. -/
  satMap_disjoint_union : ∀ T₁ T₂ : Finset ↥S.primes, Disjoint T₁ T₂ →
    satMap (T₁ ∪ T₂) = satMap T₁ + satMap T₂

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
- `reedy : ReedyDecomp S carrier N`: the Moore–Reedy splitting
  `M ≅ L̂ ⊕ Q` with `dγ = Nβ`, independent of jet level;
- `apex`/`history_apex_eq`: history realizations share the same terminal
  structural apex.

REVISION NOTE 4 (2026-10-10): History/ledger deepening (paper (iii)):
- `redHist`: the *reduced insertion history* at level `n` — the
  irredundant ledger of jet levels `3..n` as a `List (Fin (n-2))`;
- `redHist_nodup`: reducedness — no insertion step is repeated;
- `redHist_complete`: nondegeneracy — every jet level occurs;
- `histBlocks`/`histBlocks_eq`: the finite family of *closed history
  blocks* at level `n`, proved equal to the reduced-history entries
  ("the same finite family of closed history blocks", paper (iii)).

REVISION NOTE 5 (2026-10-11): Readout/history deepening (paper (v)/(iii)):
- `readout`/`readout_support`/`readout_order`/`readout_latch_comm`: a
  readout map `carrier → motivic_moore_reedy` whose support and
  coefficient order are `S`/`N` and which commutes with (is invariant
  under) every jet successor — the machine-checked weak form of the
  readout closure (paper (v)): readout objects are independent of jet
  level and commute with jet successors;
- `jet_tower.history_restrict`: cross-level history compatibility —
  the `m`-level history restricted to levels `3..n` is the `n`-level
  history (reduced history transport across levels, paper (iii));
- `jet_tower.readout_mixed_comm`: a mixed diagram (support deletion +
  jet successor + readout) commuting strictly, an instance of the
  mixed-diagram closure in Theorem 25.14's conclusion.

LIMITATIONS (P1-2): The bar-complex constancy (iv) needs spectral
machinery, not formalized here. The full Hall/root–Bass/CRT-hybrid/
Karoubi readout content of (v) also needs spectral machinery;
`readout`/`readout_latch_comm` record only the jet-level invariance
and support/order content (a weak but machine-checked form of (v)).
History pseudonaturality (iii, the bicategorical 2-cell coherences:
associators, unitors, reorderings, mixed deletion–insertion 2-cells)
is not formalized; `redHist` / `histBlocks` / `history_restrict`
record the 1-categorical ledger content (reduced histories, closed
blocks, cross-level transport). The combinatorial proper-face latching
colimit is background; `ReedyDecomp` records its algebraic shadow. -/
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
  /-- (iii) Reduced insertion history at level `n`: the irredundant
      ledger of jet levels `3..n` (paper (iii): "reduced insertion
      history"). -/
  redHist : (n : ℕ) → 3 ≤ n → List (Fin (n - 2))
  /-- Reducedness: no insertion step is repeated. -/
  redHist_nodup : ∀ (n : ℕ) (h : 3 ≤ n), (redHist n h).Nodup
  /-- Nondegeneracy: every jet level `3..n` occurs in the reduced
      history (no level is dropped). -/
  redHist_complete : ∀ (n : ℕ) (h : 3 ≤ n) (k : Fin (n - 2)),
    k ∈ redHist n h
  /-- (iii) The finite family of closed history blocks at level `n`
      (paper (iii): "the same finite family of closed history blocks"). -/
  histBlocks : (n : ℕ) → 3 ≤ n → Finset (Fin (n - 2))
  /-- The history blocks are exactly the reduced-history entries. -/
  histBlocks_eq : ∀ (n : ℕ) (h : 3 ≤ n),
    histBlocks n h = (redHist n h).toFinset
  /-- (i) Support–jet closure: support deletion on the carrier.
      Deleting the primes in `T` from the support. -/
  delMap : Finset ↥S.primes → carrier → carrier
  /-- (i) Support deletion commutes with the jet successor (latch):
      "support deletion and jet successor commute" (paper (i)). -/
  del_succ_comm : ∀ (T : Finset ↥S.primes) (n : ℕ) (h : 3 ≤ n) (x : carrier),
    delMap T (latch n h x) = latch n h (delMap T x)
  /-- (ii) Reedy decomposition: the Moore–Reedy splitting `M ≅ L̂ ⊕ Q`
      with `dγ = Nβ`, independent of the jet level (paper (ii)). -/
  reedy : ReedyDecomp S carrier N
  /-- (iii) History closure: the terminal structural apex shared by all
      jet-level history realizations (paper (iii)). -/
  apex : motivic_moore_reedy
  /-- (iii) Every history's terminal entry is the apex. -/
  history_apex_eq : ∀ (n : ℕ) (h : 3 ≤ n),
    history n h ⟨n - 3, by omega⟩ = apex
  /-- (v) Readout: the downstream readout of a jet-level state.
      Paper (v) ("Readout closure"): the Hall/root–Bass realization,
      highest-face detector, CRT-hybrid quotient and cellular Karoubi
      splitting commute with every jet successor, and their underlying
      objects are independent of jet level. This field records the
      readout map at the formal-interface level; the laws below are
      the machine-checked weak form (jet-level invariance and
      support/order content). -/
  readout : carrier → motivic_moore_reedy
  /-- (v) The readout has support `S` (independent of jet level). -/
  readout_support : ∀ (x : carrier), (readout x).support = S
  /-- (v) The readout has coefficient order `N` (independent of jet
      level). -/
  readout_order : ∀ (x : carrier), (readout x).coeffOrder = N
  /-- (v) Readout commutes with the jet successor: the readout is
      independent of jet level. LIMITATION: this is the weak form of
      the readout closure; the full Hall/face/CRT/Karoubi content
      needs spectral machinery (see the structure docstring). -/
  readout_latch_comm : ∀ (n : ℕ) (h : 3 ≤ n) (x : carrier),
    readout (latch n h x) = readout x

namespace jet_tower

variable {S : finite_ordered_support} {N : ℕ}

/-- The finite ledger for ceiling `M`: restriction of the tower to
    `3 ≤ n ≤ M`, as a `Fin (M - 2)`-indexed family (level `k.val + 3`). -/
def ledger (T : jet_tower S N) (M : ℕ) (_hM : 3 ≤ M) :
    Fin (M - 2) → motivic_moore_reedy :=
  fun k => T.atLevel (k.val + 3) (by omega)

/-- Cross-ceiling no-growth: the `M₁`-ledger is the restriction of the
    `M₂`-ledger (for `M₁ ≤ M₂`), because both come from the same tower. -/
theorem ledger_restrict (T : jet_tower S N) (M₁ M₂ : ℕ)
    (h1 : 3 ≤ M₁) (h2 : 3 ≤ M₂) (hle : M₁ ≤ M₂) (k : Fin (M₁ - 2)) :
    T.ledger M₁ h1 k =
      T.ledger M₂ h2 ⟨k.val, by omega⟩ := rfl

/-- Nondegeneracy of the history blocks: every jet level `3..n` occurs
    as a closed history block (paper (iii)). -/
theorem histBlocks_full (T : jet_tower S N) (n : ℕ) (h : 3 ≤ n)
    (k : Fin (n - 2)) : k ∈ T.histBlocks n h := by
  rw [T.histBlocks_eq n h, List.mem_toFinset]
  exact T.redHist_complete n h k

/-- Cross-level history compatibility (paper (iii)): the `m`-level
    history restricted to jet levels `3..n` (for `n ≤ m`) is the
    `n`-level history — reduced history transport across levels. -/
theorem history_restrict (T : jet_tower S N) (n m : ℕ)
    (hn : 3 ≤ n) (hm : 3 ≤ m) (hle : n ≤ m) (k : Fin (n - 2)) :
    T.history m hm ⟨k.val, by omega⟩ = T.history n hn k := by
  rw [T.history_eq, T.history_eq]

/-- Mixed diagram commutation (paper (v) + (i)): readout commutes with
    the support-deletion/jet-successor composite — an instance of the
    strict mixed-diagram closure in Theorem 25.14's conclusion. -/
theorem readout_mixed_comm (T : jet_tower S N) (T₀ : Finset ↥S.primes)
    (n : ℕ) (h : 3 ≤ n) (x : T.carrier) :
    T.readout (T.delMap T₀ (T.latch n h x)) = T.readout (T.delMap T₀ x) := by
  rw [T.del_succ_comm, T.readout_latch_comm]

end jet_tower

end SelmerCartanMotiveTowers
