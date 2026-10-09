import Mathlib.Algebra.Ring.Basic
import Mathlib.Data.ZMod.Basic
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
    The `isOdd` predicate marks the odd-degree elements; the differential is
    odd (`d` flips parity) and satisfies `d² = 0` and the graded Leibniz rule. -/
structure SuperDGA where
  A : Type
  [ring : Ring A]
  isOdd : A → Prop
  [decPred : DecidablePred isOdd]
  d : A → A
  d_add : ∀ a b, d (a + b) = d a + d b
  d_squared : ∀ a, d (d a) = 0
  leibniz : ∀ a b, d (a * b) = d a * b + (if isOdd a then (-1 : A) else 1) * (a * d b)

namespace SuperDGA

variable (S : SuperDGA)

instance : Ring S.A := S.ring
instance : DecidablePred S.isOdd := S.decPred

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
  have h_leib := S.leibniz X X
  rw [if_pos hX] at h_leib
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

/-- A Maurer-Cartan element: `X` with `F(X) = 0`. -/
def IsMaurerCartan (X : S.A) : Prop :=
  curvature S X = 0

/-- A gauge unit: a degree-0 (even) element `g` with `dg = 0` that is a unit.
    The paper's truncated gauge (`g = 1 +` positive PD degree) refines this. -/
structure GaugeUnit where
  g : S.A
  g_inv : S.A
  hg_even : ¬S.isOdd g
  hg_inv_even : ¬S.isOdd g_inv
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
    unit, and parity. -/
structure DGAHom (S T : SuperDGA) where
  toFun : S.A → T.A
  map_mul : ∀ a b, toFun (a * b) = toFun a * toFun b
  map_add : ∀ a b, toFun (a + b) = toFun a + toFun b
  map_d : ∀ a, toFun (S.d a) = T.d (toFun a)
  map_one : toFun 1 = 1
  map_odd : ∀ a, T.isOdd (toFun a) ↔ S.isOdd a

/-- Naturality (clause iv): DGA homomorphisms preserve curvature.
    This is the algebraic core of the paper's naturality statement:
    curvature is functorial under dg-algebra maps. -/
theorem naturality (F : DGAHom S T) (X : S.A) :
    F.toFun (SuperDGA.curvature S X) = SuperDGA.curvature T (F.toFun X) := by
  unfold SuperDGA.curvature
  rw [F.map_add, F.map_d, F.map_mul]

end SuperDGA

end SelmerCartanMotiveTowers
