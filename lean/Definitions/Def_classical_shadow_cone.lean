import Mathlib.Data.ZMod.Basic
import Mathlib.GroupTheory.SpecificGroups.Cyclic

namespace SelmerCartanMotiveTowers

/-! # Classical Moore cones (target of the shadow functor)

Paper reference: `def:cartan-moore-classical-shadow` and
`lem:classical-moore-order-reduction` (§27).  The paper defines

  Q_{d,ℓ} := Cone(d : T_ℓ → T_ℓ)[-1]

the (shifted) mapping cone of multiplication by `d` on the toric object.
As a 2-term complex this is `ℤ --[d]--> ℤ` (degrees 0 → 1); its `H⁰` is
`ZMod d`, and every computation the paper needs (order reduction, the
standard multiplication-by-`N` Moore presentation) happens via `d` and
`ZMod d`.

Implementation note: we do not build this via
`CochainComplex.mappingCone`, because its `HasHomotopyCofiber` instance
does not synthesize through `HomologicalComplex.single`'s `dite`-based
terms.  The data below *is* the mapping cone, given directly.
-/

/-- The classical Moore cone `Q_d`: recorded by its degree `d : ℕ`.

The underlying 2-term complex is `ℤ --[d]--> ℤ`; see `ClassicalMooreCone.diff`.
Its `H⁰` (the Moore line) is `ZMod d`; see `ClassicalMooreCone.line`. -/
structure ClassicalMooreCone where
  d : ℕ

namespace ClassicalMooreCone

/-- The differential of the 2-term complex: multiplication by `d`. -/
def diff (Q : ClassicalMooreCone) : ℤ →+ ℤ :=
  Q.d • AddMonoidHom.id ℤ

/-- The Moore line: `H⁰` of the cone, i.e. `ZMod d`. -/
def line (Q : ClassicalMooreCone) : Type :=
  ZMod Q.d

/-- The order-reduction map `q_{d,d'} : Q_d → Q_{d'}` of
`lem:classical-moore-order-reduction`, on `H⁰`.  The paper gets it from
functoriality of cones applied to the square
`T --[d]--> T / |d/d'  |1 / T --[d']--> T`; on `H⁰ = ZMod` it is the
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

/-- The cone of zero: `Q_0` has `H⁰ = ZMod 0 = ℤ`, the Artin object. -/
theorem line_zero : ZMod 0 = ℤ := rfl

/-- The Moore line has exact order `d`: the generator has `addOrderOf = d`.
This is the `ord[b] = d` the paper's shadow preserves. -/
theorem line_order {d : ℕ} [NeZero d] :
    addOrderOf (1 : ZMod d) = d :=
  ZMod.addOrderOf_one d

end ClassicalMooreCone

/-- Artin object: the cone of the zero map (`d = 0`), i.e. `T ⊕ T[1]`
whose `H⁰` is `ℤ`.  Paper: `thm:classical-low-sector-comparison` (i). -/
def IsArtin (Q : ClassicalMooreCone) : Prop :=
  Q.d = 0

/-- Standard multiplication-by-`N` Moore presentation: a nontrivial cone
(`d > 0`), whose differential is `d • 𝟙`.  The paper's relation `dc = Nb`
becomes exactly this.  Paper: `thm:classical-low-sector-comparison` (ii). -/
def IsMoorePresentation (Q : ClassicalMooreCone) : Prop :=
  0 < Q.d

end SelmerCartanMotiveTowers
