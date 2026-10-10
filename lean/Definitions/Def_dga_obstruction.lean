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

This file formalizes the **parity-graded** DGA core. The four clauses are:
- (i) **Cocycle**: `bianchi_cocycle` gives `dF = F·X - X·F`; when the
  commutator vanishes (the PD-degree-counting conclusion), `dF = 0`.
- (ii) **Lifting**: `curvature_expand` gives
  `F(X+Y) = F(X) + dY + XY + YX + Y²`; in the paper, `Y = X_{n+1}` has
  PD degree `n+1`, so the last three terms vanish in degree `n+1`.
- (iii) **Gauge**: The gauge action by conjugation is defined
  (`gaugeAct`); the curvature-conjugation formula is noted as future work
  (requires careful handling of the unit axioms).
- (iv) **Naturality**: DGA homomorphisms preserve curvature
  (`naturality`, proved).

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
- **PD filtration**: Not formalized. The paper's PD-degree counting
  ("higher terms have higher weight") is represented by the algebraic
  form of the identities; a future refinement may add an ℕ-weight grading.
- **Filler torsor**: The full affine `H¹`-torsor structure is not formalized.
  The key algebraic step (curvature expansion) is proved.
- **Gauge conjugation formula**: The definition `gaugeAct` is given, but the
  proof that `F(gXg⁻¹) = g·F(X)·g⁻¹` is deferred (technical unit axioms).
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

end SelmerCartanMotiveTowers
