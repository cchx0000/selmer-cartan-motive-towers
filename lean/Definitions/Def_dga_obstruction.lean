import Mathlib.Algebra.Ring.Basic
import Mathlib.Algebra.Group.Subgroup.Basic
import Mathlib.Tactic.Abel

namespace SelmerCartanMotiveTowers

/-!
# Differential graded algebras and the obstruction recursion (P1-3, M2)

This file defines differential graded algebras (DGAs) and proves the Bianchi
identity and its consequences for the obstruction recursion (Theorem 9.4,
`P1C-thm:universal-higher-obstruction-recursion`).

## Design: parity-graded DGA

We use a **parity-graded** (ℤ/2-graded, "super") DGA rather than a full
ℤ-graded one with dependent types. This is a real mathematical object
(supermathematics), and it captures exactly what the Bianchi identity needs:
the sign in the Leibniz rule depends only on the parity of the degree.

A full ℤ-grading with `carrier : ℤ → Type` leads to intractable index
arithmetic in Lean 4 (`(i+j)+k` vs `i+(j+k)` casts for associativity).
The parity grading avoids this while preserving the algebraic essence.

## Mathematical content

For an odd element `X`, the **curvature** is `F(X) = dX + X²`.
The **Bianchi identity** (proved below) is:
```
dF(X) + X·F(X) - F(X)·X = 0.
```

## Relation to the paper

The paper's Theorem 9.4 works in a PD-filtered setting: `X_{≤n}` is a marked
n-jet (positive PD degree), and `Ω_{n+1}` is the PD-degree-(n+1) component of
the curvature. The proof uses Bianchi plus PD-degree counting: the terms
`X·F` and `F·X` have PD degree ≥ n+2, so taking the degree-(n+1) component
of Bianchi gives `dΩ_{n+1} = 0`.

This file formalizes the **parity-graded** DGA core. The clauses are:
- (i) **Cocycle**: `bianchi_cocycle` gives `dF = F·X - X·F`; when the
  commutator vanishes (the PD-degree-counting conclusion), `dF = 0`.
- (ii) **Lifting**: `curvature_expand` gives
  `F(X+Y) = F(X) + dY + XY + YX + Y²`; in the paper, `Y = X_{n+1}` has
  PD degree `n+1`, so the last three terms vanish in degree `n+1`.
- (iii) **Gauge**: The gauge action by conjugation is defined
  (`gaugeAct`), and the curvature-conjugation formula
  `F(g·X·g⁻¹) = g·F(X)·g⁻¹` is proved (`curvature_gauge_conj`) for even
  gauge units with `dg = 0`: the differential part via `d_gauge_conj`
  (using the auxiliary right Leibniz rule `d_mul_right_even`), the square
  part by telescoping with the two-sided inverse.
- (iv) **Naturality**: DGA homomorphisms preserve curvature
  (`naturality`, proved).
- (v) **Filtered gauge naturality**: a minimal `PDFiltration` (decreasing
  ℕ-indexed levels with inclusions, even-multiplication compatibility, and
  level projections `proj n`) is defined; gauge conjugation preserves each
  level (`gaugeAct_mem_filt`) and commutes with the projections
  (`gaugeAct_proj_comm`), the algebraic core of the paper's
  gauge-invariance clause.

## LIMITATIONS (P1-3)

- **Grading vs. full super-structure**: the ℤ/2-grading is structural
  (`evenPart`/`oddPart` subgroups, four parity multiplication laws, `d`
  flipping parity, `isOdd` characterized by `isOdd_eq`), but `isOdd` still
  only marks *homogeneous* odd elements; mixed even+odd elements are
  classified as not-odd. A full treatment would thread homogeneous
  decompositions through every statement.
- **Leibniz revision (2026-10-10)**: the old single `leibniz` field used
  `if isOdd a` and mis-signed mixed elements — e.g. in the standard super
  DGA `Λ_ℚ(θ)` with `dθ = 1`, on the mixed element `a = 1 + θ` and `b = θ`
  the old rule gave `1 + 2θ` where the true value is `1`, so the interface
  excluded this valid model. It is replaced by `leibniz_even` /
  `leibniz_odd` on homogeneous inputs plus linear extension
  (`SuperDGA.leibniz_of_decomp`), restoring the model. `GaugeUnit` now
  requires evenness as positive subgroup membership (`g ∈ evenPart`)
  rather than the weak `¬ isOdd g`, and `DGAHom` preserves parity as
  subgroup membership, allowing graded maps that send a nonzero odd
  element to `0`. The truncated gauge with an odd part is still future
  work.
- **PD filtration**: Partially formalized. `PDFiltration` provides the
  level-indexed subgroups, level inclusions (`mono`), even-multiplication
  compatibility, and the level projections `proj n` (canonical on the PD
  monomial basis, cf. paper L2773), with filtered naturality of gauge
  conjugation proved (`gaugeAct_mem_filt`, `gaugeAct_proj_comm`). The
  associated graded, marked jets, and the `dΩ = 0` degree-counting
  conclusion are still future work.
- **Filler torsor**: The full affine `H¹`-torsor structure is not formalized.
  The key algebraic step (curvature expansion) is proved.
- **Gauge conjugation formula**: Proved for the even `dg = 0` unit model
  (`curvature_gauge_conj`, via `d_gauge_conj` and `d_mul_right_even`). The
  paper's truncated gauge (`g = 1 +` positive PD degree, possibly with an
  odd part) is still future work.
- **Full ℤ-grading**: We use parity (ℤ/2) only; the ℤ-grading is a refinement.
-/

/-- A parity-graded differential graded algebra ("super-DGA").

    The grading is **structural**, not a bare predicate: `evenPart`/`oddPart`
    are additive subgroups giving an even/odd decomposition of `A`, with the
    four parity multiplication laws and `d` flipping parity. `isOdd` marks
    the *homogeneous* odd elements and is tied to the grading by `isOdd_eq`,
    so it is no longer an arbitrary predicate.

    The Leibniz rule is stated on **homogeneous** inputs (`leibniz_even` for
    even elements, `leibniz_odd` with the Koszul sign `-1` for homogeneous
    odd elements) and extends linearly to arbitrary mixed elements via
    `SuperDGA.leibniz_of_decomp`. This repairs the old single-`leibniz`
    interface with `if isOdd a`, which mis-signed mixed elements and
    excluded genuine models such as `Λ_ℚ(θ)` with `dθ = 1`.

    Note on the sign: in characteristic 2 the `(-1 : A)` in `leibniz_odd`
    equals `1`; the grading laws themselves are characteristic-free. -/
structure SuperDGA where
  A : Type
  [ring : Ring A]
  isOdd : A → Prop
  [decPred : DecidablePred isOdd]
  d : A → A
  d_add : ∀ a b, d (a + b) = d a + d b
  d_squared : ∀ a, d (d a) = 0
  /-- 偶/奇分解 (even/odd decomposition): the even part is an additive
      subgroup, closed under multiplication and containing `1`. -/
  evenPart : AddSubgroup A
  one_even : (1 : A) ∈ evenPart
  even_mul : ∀ a b, a ∈ evenPart → b ∈ evenPart → a * b ∈ evenPart
  /-- The odd part is an additive subgroup. -/
  oddPart : AddSubgroup A
  /-- 乘法次数 (multiplication respects parity): the four parity laws,
      stated for the subgroups so they are zero-safe. -/
  mul_even_odd : ∀ a b, a ∈ evenPart → b ∈ oddPart → a * b ∈ oddPart
  mul_odd_even : ∀ a b, a ∈ oddPart → b ∈ evenPart → a * b ∈ oddPart
  mul_odd_odd : ∀ a b, a ∈ oddPart → b ∈ oddPart → a * b ∈ evenPart
  /-- Every element decomposes as even + odd. -/
  decomp : ∀ a : A, ∃ e ∈ evenPart, ∃ o ∈ oddPart, e + o = a
  /-- The decomposition is disjoint: only `0` is both even and odd. -/
  disj : ∀ a : A, a ∈ evenPart → a ∈ oddPart → a = 0
  /-- d 翻转次数 (`d` flips parity). -/
  d_of_even : ∀ a : A, a ∈ evenPart → d a ∈ oddPart
  d_of_odd : ∀ a : A, a ∈ oddPart → d a ∈ evenPart
  /-- `isOdd` is the homogeneous-odd predicate, determined by the grading. -/
  isOdd_eq : ∀ a : A, isOdd a ↔ (a ∈ oddPart ∧ a ∉ evenPart)
  /-- Leibniz rule for homogeneous even elements (no Koszul sign).
      Placed after the grading fields since it refers to `evenPart`. -/
  leibniz_even : ∀ a b, a ∈ evenPart → d (a * b) = d a * b + a * d b
  /-- Leibniz rule for homogeneous odd elements (Koszul sign `-1`).
      Mixed elements are handled by `SuperDGA.leibniz_of_decomp` via the
      even/odd decomposition. -/
  leibniz_odd : ∀ a b, isOdd a → d (a * b) = d a * b + (-1 : A) * (a * d b)

namespace SuperDGA

variable (S : SuperDGA)

instance : Ring S.A := S.ring
instance : DecidablePred S.isOdd := S.decPred

/-- `0` is even. -/
theorem isOdd_zero : ¬ S.isOdd 0 := by
  rw [S.isOdd_eq]
  rintro ⟨_, hne⟩
  exact hne (zero_mem S.evenPart)

/-- `1` is even. -/
theorem isOdd_one : ¬ S.isOdd 1 := by
  rw [S.isOdd_eq]
  rintro ⟨_, hne⟩
  exact hne S.one_even

/-- 乘法次数: odd · odd is even (zero-safe via the subgroup law). -/
theorem mul_odd_odd_not_odd (a b : S.A) (ha : S.isOdd a) (hb : S.isOdd b) :
    ¬ S.isOdd (a * b) := by
  rw [S.isOdd_eq] at ha hb ⊢
  rintro ⟨_, hne⟩
  exact hne (S.mul_odd_odd a b ha.1 hb.1)

/-- 乘法次数: even · odd is odd-or-zero. -/
theorem mul_even_odd_cases (a b : S.A) (ha : ¬ S.isOdd a) (hb : S.isOdd b)
    (he : a ∈ S.evenPart) :
    S.isOdd (a * b) ∨ a * b = 0 := by
  by_cases h0 : a * b = 0
  · exact Or.inr h0
  · left
    rw [S.isOdd_eq]
    refine ⟨S.mul_even_odd a b he ((S.isOdd_eq b).mp hb).1, ?_⟩
    intro hmem
    exact h0 (S.disj (a * b) hmem (S.mul_even_odd a b he ((S.isOdd_eq b).mp hb).1))

/-- d 翻转次数: `d` sends odd elements to even ones. -/
theorem d_flips_odd (a : S.A) (ha : S.isOdd a) : ¬ S.isOdd (S.d a) := by
  rw [S.isOdd_eq] at ha ⊢
  rintro ⟨_, hne⟩
  exact hne (S.d_of_odd a ha.1)

/-- Curvature of an element: `F(X) = dX + X²`.
    For the Bianchi identity we need `X` odd (see `bianchi`). -/
def curvature (X : S.A) : S.A :=
  S.d X + X * X

/-- The Bianchi identity: `dF(X) + X·F(X) - F(X)·X = 0` for odd `X`.

    Proof: `dF = d(dX) + d(X²) = 0 + ((dX)X - X(dX))` by `d² = 0` and Leibniz
    (with sign `-1` since `X` is odd). Then `X·F = X(dX) + X³` and
    `F·X = (dX)X + X³` by distributivity. The sum telescopes to `0` using
    associativity of `X³`. -/
theorem bianchi (X : S.A) (hX : S.isOdd X) :
    S.d (curvature S X) + X * (curvature S X) - (curvature S X) * X = 0 := by
  unfold curvature
  rw [S.d_add, S.d_squared]
  have h_leib := S.leibniz_odd X X hX
  simp only [zero_add]
  rw [h_leib, mul_add, add_mul]
  have h_assoc : X * (X * X) = (X * X) * X := (mul_assoc X X X).symm
  rw [h_assoc]
  have h_neg : (-1 : S.A) * (X * S.d X) = -(X * S.d X) := neg_one_mul _
  rw [h_neg]
  abel

/-- Bianchi rearranged: `dF = F·X - X·F` (the cocycle clause).

    In the paper's PD-filtered setting, the RHS has PD degree ≥ n+2 while
    `dF` has degree n+1, so taking the degree-(n+1) component gives `dΩ = 0`. -/
theorem bianchi_cocycle (X : S.A) (hX : S.isOdd X) :
    S.d (curvature S X) = (curvature S X) * X - X * (curvature S X) := by
  have h := bianchi S X hX
  have h2 : S.d (curvature S X) + (X * (curvature S X) - (curvature S X) * X) = 0 := by
    calc S.d (curvature S X) + (X * (curvature S X) - (curvature S X) * X)
        = S.d (curvature S X) + X * (curvature S X) - (curvature S X) * X := by abel
      _ = 0 := h
  have h3 := eq_neg_of_add_eq_zero_left h2
  calc S.d (curvature S X)
      = -(X * (curvature S X) - (curvature S X) * X) := h3
    _ = (curvature S X) * X - X * (curvature S X) := by abel

/-- Curvature expansion (the lifting criterion):
    `F(X+Y) = F(X) + dY + XY + YX + Y²`.

    In the paper, `Y = X_{n+1}` has PD degree `n+1`; then `XY`, `YX`, `Y²`
    have PD degree ≥ n+2, so in degree `n+1` we get
    `pr_{n+1} F(X+Y) = Ω_{n+1} + dY`. Hence a lift (with `F = 0`) exists
    iff `Ω_{n+1} = -dY` for some `Y`, i.e. iff the obstruction class
    vanishes. -/
theorem curvature_expand (X Y : S.A) :
    curvature S (X + Y) =
      curvature S X + S.d Y + X * Y + Y * X + Y * Y := by
  unfold curvature
  rw [S.d_add, add_mul, mul_add, mul_add]
  abel

/-- Leibniz rule extended to arbitrary (possibly mixed) elements by linear
    extension along the even/odd decomposition.

    The old single-`leibniz` interface used `if isOdd a` and therefore
    classified a mixed element such as `a = 1 + θ` in `Λ_ℚ(θ)` (with
    `dθ = 1`) as not-odd, evaluating the right-hand side at the wrong sign:
    for `b = θ` the old rule gives `1 + 2θ` where the true value is `1`.
    With the decomposition `a = e + o` the correct formula is the sum of
    the homogeneous rules. -/
theorem leibniz_of_decomp (a b e o : S.A) (he : e ∈ S.evenPart)
    (ho : S.isOdd o) (h : e + o = a) :
    S.d (a * b) =
      (S.d e * b + e * S.d b) + (S.d o * b + (-1 : S.A) * (o * S.d b)) := by
  conv_lhs => rw [← h]
  rw [add_mul, S.d_add, S.leibniz_even e b he, S.leibniz_odd o b ho]

/-- A Maurer-Cartan element: `X` with `F(X) = 0`. -/
def IsMaurerCartan (X : S.A) : Prop :=
  curvature S X = 0

/-- A gauge unit: a degree-0 (even) element `g` with `dg = 0` that is a unit.

    Evenness is required positively as subgroup membership (`g ∈ evenPart`),
    not as the negated predicate `¬ isOdd g` (which a mixed even+odd element
    also satisfies). The paper's truncated gauge (`g = 1 +` positive PD
    degree, which may have an odd part) is a further refinement not captured
    by this even-unit model. -/
structure GaugeUnit where
  g : S.A
  g_inv : S.A
  hg_even : g ∈ S.evenPart
  hg_inv_even : g_inv ∈ S.evenPart
  dg_eq : S.d g = 0
  dg_inv_eq : S.d g_inv = 0
  mul_inv : g * g_inv = 1
  inv_mul : g_inv * g = 1

/-- Gauge action by conjugation: `X^g = g·X·g⁻¹`. -/
def gaugeAct (u : S.GaugeUnit) (X : S.A) : S.A :=
  u.g * X * u.g_inv

/-- `d 0 = 0`, from additivity of `d`. -/
theorem d_zero : S.d 0 = 0 := by
  have h := S.d_add 0 0
  rw [add_zero] at h
  exact add_eq_right.mp h.symm

/-- Right Leibniz rule for an even second factor with vanishing differential:
    if `b` is even and `d b = 0`, then `d (a * b) = (d a) * b` for *every* `a`.

    Proof by even/odd decomposition of `a` (`S.decomp`): on the even part this
    is `leibniz_even`; on the odd part it is `leibniz_odd` (the Koszul sign
    term `(-1) * (o * d b)` vanishes since `d b = 0`), with the zero case
    handled by disjointness (`S.disj`). This is the interface lemma needed to
    push `d` through the right-hand gauge factor `g⁻¹`. -/
theorem d_mul_right_even (a b : S.A) (hb : b ∈ S.evenPart) (hdb : S.d b = 0) :
    S.d (a * b) = S.d a * b := by
  classical
  obtain ⟨e, he, o, ho, rfl⟩ := S.decomp a
  have he0 : e * S.d b = 0 := by rw [hdb, mul_zero]
  rw [add_mul, S.d_add, S.d_add, add_mul, S.leibniz_even e b he, he0, add_zero]
  by_cases hoe : o ∈ S.evenPart
  · have ho0 : o = 0 := S.disj o hoe ho
    subst ho0
    simp [S.d_zero]
  · have hoo : S.isOdd o := (S.isOdd_eq o).mpr ⟨ho, hoe⟩
    have hsign : (-1 : S.A) * (o * S.d b) = 0 := by rw [hdb, mul_zero, mul_zero]
    rw [S.leibniz_odd o b hoo, hsign, add_zero]

/-- Gauge conjugation commutes with `d`: for a gauge unit `u`,
    `d (g·a·g⁻¹) = g·(d a)·g⁻¹`.

    The left factor is even, so `leibniz_even` applies directly; the right
    factor is even with vanishing differential, handled by
    `d_mul_right_even`. -/
theorem d_gauge_conj (u : S.GaugeUnit) (a : S.A) :
    S.d (u.g * a * u.g_inv) = u.g * (S.d a) * u.g_inv := by
  have h1 : S.d (u.g * a) = u.g * S.d a := by
    rw [S.leibniz_even u.g a u.hg_even, u.dg_eq, zero_mul, zero_add]
  rw [S.d_mul_right_even (u.g * a) u.g_inv u.hg_inv_even u.dg_inv_eq, h1]

/-- **Curvature-conjugation formula** (Theorem 9.4 (iii), proved): for a gauge
    unit `u` (even, `dg = 0`), `F(g·X·g⁻¹) = g·F(X)·g⁻¹`.

    Proof: `F = d + (·)²`. The differential part conjugates by
    `d_gauge_conj`; the square telescopes,
    `(g·X·g⁻¹)² = g·X·(g⁻¹·g)·X·g⁻¹ = g·X²·g⁻¹`, using the two-sided inverse.
    Additivity/multiplicativity (`d_add`, `add_mul`, `mul_add`) recombines
    the two parts. This is genuine algebra, not a definitional unfolding. -/
theorem curvature_gauge_conj (u : S.GaugeUnit) (X : S.A) :
    SuperDGA.curvature S (S.gaugeAct u X) =
      u.g * (SuperDGA.curvature S X) * u.g_inv := by
  have hconj : S.d (S.gaugeAct u X) = u.g * S.d X * u.g_inv :=
    S.d_gauge_conj u X
  have hsq : (S.gaugeAct u X) * (S.gaugeAct u X) =
      u.g * (X * X) * u.g_inv := by
    show (u.g * X * u.g_inv) * (u.g * X * u.g_inv) = _
    calc (u.g * X * u.g_inv) * (u.g * X * u.g_inv)
        = u.g * X * (u.g_inv * (u.g * X)) * u.g_inv := by
          simp only [mul_assoc]
      _ = u.g * X * ((u.g_inv * u.g) * X) * u.g_inv := by
          rw [← mul_assoc u.g_inv u.g X]
      _ = u.g * X * X * u.g_inv := by
          rw [u.inv_mul, one_mul]
      _ = u.g * (X * X) * u.g_inv := by
          simp only [mul_assoc]
  show S.d (S.gaugeAct u X) + (S.gaugeAct u X) * (S.gaugeAct u X)
    = u.g * (S.d X + X * X) * u.g_inv
  rw [hconj, hsq, ← add_mul, ← mul_add]

end SuperDGA

/-!
## DGA homomorphisms and naturality
-/

namespace SuperDGA

variable {S T : SuperDGA}

/-- A homomorphism of super-DGAs: preserves multiplication, differential,
    unit, and parity.

    Parity is preserved as subgroup membership, so a graded map may send a
    nonzero odd element to `0` (which lies in both subgroups); the old
    `map_odd : ∀ a, T.isOdd (toFun a) ↔ S.isOdd a` excluded such maps. -/
structure DGAHom (S T : SuperDGA) where
  toFun : S.A → T.A
  map_mul : ∀ a b, toFun (a * b) = toFun a * toFun b
  map_add : ∀ a b, toFun (a + b) = toFun a + toFun b
  map_d : ∀ a, toFun (S.d a) = T.d (toFun a)
  map_one : toFun 1 = 1
  map_even : ∀ a, a ∈ S.evenPart → toFun a ∈ T.evenPart
  map_odd : ∀ a, a ∈ S.oddPart → toFun a ∈ T.oddPart

/-- Naturality (clause iv): DGA homomorphisms preserve curvature.
    This is the algebraic core of the paper's naturality statement:
    curvature is functorial under dg-algebra maps. -/
theorem naturality (F : DGAHom S T) (X : S.A) :
    F.toFun (SuperDGA.curvature S X) = SuperDGA.curvature T (F.toFun X) := by
  unfold SuperDGA.curvature
  rw [F.map_add, F.map_d, F.map_mul]

end SuperDGA

/-!
## PD filtration and filtered gauge naturality
-/

namespace SuperDGA

variable (S : SuperDGA)

/-- A PD filtration on a super-DGA: a decreasing ℕ-indexed family of additive
    subgroups, compatible with even multiplication, equipped with level
    projections.

    Intended semantics (paper §9, Theorem 9.4): `Filt n` holds the elements
    of PD weight ≥ n; `proj n` extracts the PD-degree-`n` component
    (canonical on the PD monomial basis, cf. paper L2773: "The PD monomial
    basis makes the coefficient projection canonical"). The even-linearity of
    `proj` says degree-0 scalars pass through the projection.

    This is the first filtration layer: levels, inclusions, and projections,
    with filtered naturality of gauge conjugation proved below. The
    associated graded, marked jets, and the `dΩ = 0` degree-counting
    conclusion are future work. -/
structure PDFiltration (S : SuperDGA) where
  Filt : ℕ → AddSubgroup S.A
  /-- 包含 (inclusion): the filtration is decreasing. -/
  mono : ∀ n m : ℕ, n ≤ m → Filt m ≤ Filt n
  /-- Filtration compatibility: left multiplication by an even element
      preserves each level. -/
  even_mul_left : ∀ (n : ℕ) (a b : S.A), a ∈ S.evenPart → b ∈ Filt n →
    a * b ∈ Filt n
  /-- Filtration compatibility: right multiplication by an even element
      preserves each level. -/
  even_mul_right : ∀ (n : ℕ) (a b : S.A), a ∈ Filt n → b ∈ S.evenPart →
    a * b ∈ Filt n
  /-- 级次投影 (level projection): extracts the PD-degree-`n` component. -/
  proj : ℕ → S.A → S.A
  proj_add : ∀ (n : ℕ) (a b : S.A), proj n (a + b) = proj n a + proj n b
  /-- The projection lands in its level. -/
  proj_mem : ∀ (n : ℕ) (a : S.A), a ∈ Filt n → proj n a ∈ Filt n
  /-- The projection kills strictly higher levels. -/
  proj_kill : ∀ (n : ℕ) (a : S.A), a ∈ Filt (n + 1) → proj n a = 0
  /-- The projection is left even-linear (degree-0 scalars pass through). -/
  proj_even_mul_left : ∀ (n : ℕ) (g a : S.A), g ∈ S.evenPart →
    proj n (g * a) = g * proj n a
  /-- The projection is right even-linear. -/
  proj_even_mul_right : ∀ (n : ℕ) (a g : S.A), g ∈ S.evenPart →
    proj n (a * g) = proj n a * g

/-- Filtered naturality of gauge conjugation (level version): conjugation by
    a gauge unit preserves each filtration level.

    This is the algebraic core of the paper's gauge-invariance clause
    (Theorem 9.4 (iii)): the gauge unit is degree-0 (even), so conjugating
    cannot move an element out of its PD level. -/
theorem gaugeAct_mem_filt (P : S.PDFiltration) (u : S.GaugeUnit) (n : ℕ)
    (X : S.A) (hX : X ∈ P.Filt n) : S.gaugeAct u X ∈ P.Filt n := by
  have h1 : u.g * X ∈ P.Filt n := P.even_mul_left n u.g X u.hg_even hX
  exact P.even_mul_right n (u.g * X) u.g_inv h1 u.hg_inv_even

/-- Filtered naturality of gauge conjugation (projection version): the level
    projection commutes with gauge conjugation.

    This is the form used in the paper's (iii): the degree-`n` component of
    the conjugated element is the conjugate of the degree-`n` component, so
    obstruction components are identified (not changed) under gauge
    transformation. -/
theorem gaugeAct_proj_comm (P : S.PDFiltration) (u : S.GaugeUnit) (n : ℕ)
    (X : S.A) : P.proj n (S.gaugeAct u X) = S.gaugeAct u (P.proj n X) := by
  show P.proj n ((u.g * X) * u.g_inv) = (u.g * (P.proj n X)) * u.g_inv
  rw [P.proj_even_mul_right n (u.g * X) u.g_inv u.hg_inv_even,
    P.proj_even_mul_left n u.g X u.hg_even]

/-- Vanishing of the projected conjugate on higher levels: if `X` already
    lies in level `n + 1`, the degree-`n` component of its gauge conjugate is
    zero. This is the algebraic shadow of the paper's "since the first
    possible curvature term has degree `n + 1`, conjugation by `g` cannot
    change that homogeneous component" (proof of (iii)). -/
theorem proj_gaugeAct_eq_zero_of_mem_succ (P : S.PDFiltration) (u : S.GaugeUnit)
    (n : ℕ) (X : S.A) (hX : X ∈ P.Filt (n + 1)) :
    P.proj n (S.gaugeAct u X) = 0 := by
  rw [S.gaugeAct_proj_comm P u n X, P.proj_kill n X hX]
  simp [SuperDGA.gaugeAct]

end SuperDGA

end SelmerCartanMotiveTowers
