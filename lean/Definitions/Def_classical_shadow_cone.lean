import Mathlib.Data.ZMod.Basic
import Mathlib.GroupTheory.SpecificGroups.Cyclic

namespace SelmerCartanMotiveTowers

/-! # Classical Moore cones (target of the shadow functor)

Paper reference: `def:cartan-moore-classical-shadow` and
`lem:classical-moore-order-reduction` (§27).  The paper defines

  Q_{d,ℓ} := Cone(d : T_ℓ → T_ℓ)[-1]

the (shifted) mapping cone of multiplication by `d` on the toric object.
The unshifted cone of `d : T → T` (with `T` in degree 0) is the 2-term
complex `ℤ --[d]--> ℤ` in degrees -1 → 0; shifting by `[-1]` moves it to
degrees 0 → 1.  Degree convention (P1-3 verifier fix, 2026-10-10): for the
2-term complex `C⁰ = ℤ --[×d]--> C¹ = ℤ`, the cokernel `ZMod d` sits in
degree **1**, i.e. it is `H¹`, not `H⁰` (indeed `H⁰ = ker(×d) = 0` for
`d ≠ 0`).  So in the paper, the Moore line `ZMod d` is `H¹` of the shifted
cone, and every computation the paper needs (order reduction, the standard
multiplication-by-`N` Moore presentation) happens via `d` and `ZMod d`.

Implementation note: we do not build this via
`CochainComplex.mappingCone`, because its `HasHomotopyCofiber` instance
does not synthesize through `HomologicalComplex.single`'s `dite`-based
terms.  The structure below records the cone's numerical invariant `d`
directly; the 2-term complex itself is NOT built in Lean.

HONESTY NOTE (2026-10-10, verifier M11 audit): `line := ZMod d` is the
paper's Moore line in the NUMERIC MODEL only.  The identification of
`ZMod d` with `H¹` of the actual 2-term complex `ℤ --[d]--> ℤ` is NOT
formalized here (the complex is not built, see above), so any "H¹ of the
cone" reading below is a paper-level assertion, not a proved one.
Likewise, `IsMoorePresentation` records only `0 < d`; it does not bind the
paper's coefficient `N` (paper (ii) sends the Moore seed to `Q_{N,ℓ}`,
i.e. `d = N`) — the exact binding is recorded by
`IsMoorePresentationAt` below, which the current background does not
assume. -/

/-- The classical Moore cone `Q_d`: recorded by its degree `d : ℕ`.

The paper's underlying 2-term complex is `ℤ --[d]--> ℤ` (degrees 0 → 1);
its differential is recorded in `ClassicalMooreCone.diff`, but the complex
itself is NOT built in Lean.
The Moore line (the paper's `H¹` = cokernel of `×d`) is MODELED by
`ZMod d`; see `ClassicalMooreCone.line` and the honesty note above. -/
structure ClassicalMooreCone where
  d : ℕ

namespace ClassicalMooreCone

/-- The differential of the 2-term complex: multiplication by `d`. -/
def diff (Q : ClassicalMooreCone) : ℤ →+ ℤ :=
  Q.d • AddMonoidHom.id ℤ

/-- The Moore line in the numeric model: `ZMod d`.

In the paper this is `H¹` of the shifted cone (the cokernel of `×d`).
That identification is NOT proved here — the cone complex is not built
(see the honesty note in the module docstring).  This is the paper's Moore
line as a plain abelian group, with the reduction maps and order facts the
paper needs proved below. -/
def line (Q : ClassicalMooreCone) : Type :=
  ZMod Q.d

/-- The order-reduction map `q_{d,d'} : Q_d → Q_{d'}` of
`lem:classical-moore-order-reduction`, on `H¹`.  The paper gets it from
functoriality of cones applied to the square
`T --[d]--> T / |d/d'  |1 / T --[d']--> T`; on `H¹ = ZMod` it is the
canonical cast. -/
def reduce (d d' : ℕ) (h : d' ∣ d) : ZMod d →+* ZMod d' :=
  ZMod.castHom h (ZMod d')

/-- `q_{d,d} = 1` (paper, after (2)). -/
theorem reduce_refl (d : ℕ) : reduce d d (dvd_refl d) = RingHom.id (ZMod d) := by
  unfold reduce
  ext x
  simp

/-- Transitivity `q_{d',d''} ∘ q_{d,d'} = q_{d,d''}` (paper, after (2)). -/
theorem reduce_trans {d d' d'' : ℕ} (h1 : d' ∣ d) (h2 : d'' ∣ d') :
    (reduce d' d'' h2).comp (reduce d d' h1) = reduce d d'' (h2.trans h1) := by
  unfold reduce
  ext x
  simp

/-- The cone of zero: `Q_0` has `H¹ = ZMod 0 = ℤ`, the Artin object. -/
theorem line_zero : ZMod 0 = ℤ := rfl

/-- The Moore line has exact order `d`: the generator has `addOrderOf = d`.
This is the `ord[b] = d` the paper's shadow preserves. -/
theorem line_order {d : ℕ} [NeZero d] :
    addOrderOf (1 : ZMod d) = d :=
  ZMod.addOrderOf_one d

end ClassicalMooreCone

/-- Artin object: the cone of the zero map (`d = 0`).

The paper's target here is `T ⊕ T[1]`, whose `H¹` (cokernel of the zero
differential) is `ℤ`; in the numeric model, `line = ZMod 0 = ℤ`
(`ClassicalMooreCone.line_zero`).
Paper: `thm:classical-low-sector-comparison` (i). -/
def IsArtin (Q : ClassicalMooreCone) : Prop :=
  Q.d = 0

/-- Standard Moore presentation: a nontrivial cone (`d > 0`), whose
differential is `d • 𝟙`.  Paper: `thm:classical-low-sector-comparison`
(ii), partially.

CAVEAT: this records only nontriviality — `0 < d`, and in particular
`d = 1` is allowed.  It does NOT bind the paper's coefficient `N`: paper
(ii) sends the primitive motivic Moore seed to `Q_{N,ℓ}` with `d = N`
exactly ("the relation `dc = Nb` becomes exactly the standard
multiplication-by-`N` Moore presentation").  That exact binding is
`IsMoorePresentationAt` below.  This predicate is the one the current
`FormalBackground.shadowMoore` assumes. -/
def IsMoorePresentation (Q : ClassicalMooreCone) : Prop :=
  0 < Q.d

/-- Exact multiplication-by-`N` Moore presentation: `d = N`.

Paper: `thm:classical-low-sector-comparison` (ii) — the primitive motivic
Moore seed maps to `Q_{N,ℓ}`, i.e. the cone whose differential is
multiplication by the seed's OWN coefficient `N`.  This is the fidelity
refinement of `IsMoorePresentation` (which only records `0 < d`).

NOT assumed by the current `FormalBackground` (its `shadowMoore` field
only gives `IsMoorePresentation`); recorded here so that the paper's
exact statement is representable without changing the background. -/
def IsMoorePresentationAt (Q : ClassicalMooreCone) (N : ℕ) : Prop :=
  Q.d = N

end SelmerCartanMotiveTowers
