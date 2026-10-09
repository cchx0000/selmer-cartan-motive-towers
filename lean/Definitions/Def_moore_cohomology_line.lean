import Mathlib.Data.ZMod.Basic
import Mathlib.Data.ZMod.QuotientGroup
import Mathlib.Tactic

namespace SelmerCartanMotiveTowers

/-- The universal Moore complex at depth two (paper §"Finite p×q² assembly",
    `P1C-eq:pq2-moore-attachment`): in the universal model, free cyclic
    summands `ℤ C_{2,1}` (degree `d-1`) and `ℤ B_{2,1}` (degree `d`) with
    differential `d C_{2,1} = (p*q^2) B_{2,1}`.
    We record the cohomological degree `d`; see `mooreDiff` for the
    differential and `mooreBoundaries` for the boundaries in degree `d`.

    LIMITATIONS: this records the complex as data (degrees + differential),
    not as a `HomologicalComplex`; the homology computation is carried out
    explicitly in `moore_cohomology` below. -/
structure moore_complex (p q : ℕ) where
  deg : ℤ

/-- The Moore differential `×(p*q^2) : ℤ → ℤ`
    (paper `P1C-eq:pq2-moore-attachment`: `d C_{2,1} = pq² B_{2,1}`). -/
def mooreDiff (p q : ℕ) : ℤ →+ ℤ where
  toFun x := (p * q ^ 2 : ℤ) * x
  map_zero' := by simp
  map_add' := fun x y => by ring

/-- Boundaries in degree `d`: `(p*q^2) • ℤ` (image of `mooreDiff`). -/
def mooreBoundaries (p q : ℕ) : AddSubgroup ℤ :=
  AddSubgroup.zmultiples (p * q ^ 2 : ℤ)

/-- The Moore cohomology line `H^d = ℤ / (p*q^2)ℤ`, concretely `ZMod (p*q^2)`
    (paper `P1C-thm:formal-pq2-order`: `[B_{2,1}]` has exact order `pq²`). -/
abbrev moore_line (p q : ℕ) := ZMod (p * q ^ 2)

/-- The universal Moore generator `[B_{2,1}] : H^d`, the class of `1`. -/
def mooreGen (p q : ℕ) : moore_line p q := 1

/-- The depth-two confluence coefficient line
    `L^{conf}_{p;q²} := L_p × L^{conf}_{q²}` (paper `P1C-def:pq2-confluence-line`),
    concretely `ZMod p × ZMod (q^2)`: the first factor is the primitive
    `p`-primary line `(ℤ/p) b_p`, the second is `W_q / q^2 W_q ≃ ℤ/q^2`
    (paper `P1C-thm:filtered-q2-line`). -/
abbrev conf_line (p q : ℕ) := ZMod p × ZMod (q ^ 2)

/-- The primitive confluence generator `(b_p, κ̃ mod q²)`. -/
def confGen (p q : ℕ) : conf_line p q := (1, 1)

/-- The residual repeated-input secondary generator `κ̄ : ZMod q`
    (paper `P1C-thm:filtered-q2-line`: `(κ̃ mod q²) mod q = κ̄ ≠ 0`). -/
def residualGen (q : ℕ) : ZMod q := 1

/-- `κ̄ ≠ 0` for prime `q` (paper `P1C-thm:filtered-q2-line`). -/
theorem residualGen_ne_zero (q : ℕ) (hq : q.Prime) : residualGen q ≠ 0 := by
  have : Fact (Nat.Prime q) := ⟨hq⟩
  -- `ZMod q` is a field for prime `q`, hence nontrivial, hence `1 ≠ 0`.
  exact one_ne_zero

/-- q-primary reduction on the confluence line: project to the `q²`-component
    and reduce modulo `q`. Under this map, the confluence generator goes to
    the residual generator `κ̄` (paper `P1C-thm:filtered-q2-line`). -/
def qPrimaryRed (p q : ℕ) : conf_line p q →+* ZMod q :=
  (ZMod.castHom (show q ∣ q ^ 2 from ⟨q, by ring⟩) (ZMod q)).comp
    (RingHom.snd (ZMod p) (ZMod (q ^ 2)))

/-- The cohomology of the Moore complex is the Moore line:
    `ℤ ⧸ (p*q^2)ℤ ≃+ ZMod (p*q^2)` (paper `P1C-thm:formal-pq2-order`). -/
def moore_cohomology (p q : ℕ) :
    (ℤ ⧸ mooreBoundaries p q) ≃+ moore_line p q := by
  have h : ((p * q ^ 2 : ℕ) : ℤ).natAbs = p * q ^ 2 := Int.natAbs_natCast _
  show (ℤ ⧸ AddSubgroup.zmultiples ((p * q ^ 2 : ℕ) : ℤ)) ≃+ ZMod (p * q ^ 2)
  rw [← h]
  exact Int.quotientZMultiplesEquivZMod _

end SelmerCartanMotiveTowers
