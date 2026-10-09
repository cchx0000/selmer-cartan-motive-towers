import Mathlib.NumberTheory.NumberField.Basic
import Mathlib.Data.Nat.Prime.Defs

namespace SelmerCartanMotiveTowers

/-- Arithmetic background package for Theorem 6.5
(`P1L-thm:ray-class-primitive`, primitive ray-class three-prime construction).

This packages the §6 arithmetic inputs used by the proof. The paper states
(§6, L1062–1063): "The construction uses only Kummer theory, ray class
fields, local duality and Chebotarev; we use the standard class-field
conventions of [NeukirchANT]." All of the following are CITED to Neukirch's
*Algebraic Number Theory*, NOT proved in the paper. The paper proves only the
local verifications (deep modulus lemma, pointwise cup vanishing, the
Heisenberg lift group theory).

FIELDS:
- The basic setup (`N`, `F`, `ζ`, `Place`, `KChar`, predicates): the paper's
  §6 arithmetic background notions.
- `firstTwoRays`: conclusion of `P1L-lem:first-two-rays` (paper proves it
  using ray class fields + Kummer + global reciprocity; recorded here as an
  input for the skeleton).
- `heisenbergLift`: conclusion of `P1L-prop:ray-heisenberg-lift` (paper proves;
  the lift obstruction is the cup product, pure group cohomology).
- `thirdRay`: the Chebotarev + ray-class-field input producing the third
  place `v₃` with Frobenius `(z,1)` in the compositum, the Kummer character
  `χ₃`, and the local cup vanishing (cited: Neukirch ANT).
- `masseyExact`: local Tate duality (the local invariant at `v₃` is a unit,
  normalized to 1) + global reciprocity (cited: Neukirch ANT), giving the
  exact-order-`N` triple Massey cocycle.

STATUS: background hypothesis package. Each field is labeled with its source.
These are the deep arithmetic inputs; future work may replace them with
concrete proofs from class field theory. -/
structure ClassFieldBackground where
  N : Nat
  hNodd : Odd N
  hN1 : 1 < N
  /-- Finite places of the number field `F` (which contains the primitive
  `N`-th roots of unity; `F` itself is not needed for the combinatorial
  inputs below). -/
  Place : Type
  nonempty_Place : Nonempty Place
  aboveN : Place → Prop
  KChar : Type
  nonempty_KChar : Nonempty KChar
  exactOrderN : KChar → Prop
  ramSupp : KChar → Place → Prop
  cupVanishes : KChar → KChar → Prop
  heisLift : KChar → KChar → Prop
  masseyOrderN : KChar → KChar → KChar → Prop
  /-- Conclusion of `P1L-lem:first-two-rays`: two places with Kummer
  characters of exact order `N`, disjoint ramification, vanishing cup. -/
  firstTwoRays :
    ∃ (v : Fin 2 → Place) (χ : Fin 2 → KChar),
      Function.Injective v ∧
      (∀ i, ¬ aboveN (v i)) ∧
      (∀ i, exactOrderN (χ i)) ∧
      (∀ (i : Fin 2) (w : Place), ramSupp (χ i) w ↔ w = v i) ∧
      cupVanishes (χ 0) (χ 1) ∧ cupVanishes (χ 1) (χ 0)
  /-- Conclusion of `P1L-prop:ray-heisenberg-lift`: the Heisenberg lift. -/
  heisenbergLift :
    ∀ (v : Fin 2 → Place) (χ : Fin 2 → KChar),
      Function.Injective v →
      (∀ i, ¬ aboveN (v i)) →
      (∀ i, exactOrderN (χ i)) →
      (∀ (i : Fin 2) (w : Place), ramSupp (χ i) w ↔ w = v i) →
      cupVanishes (χ 0) (χ 1) →
      heisLift (χ 0) (χ 1)
  /-- Chebotarev + ray class field input: the third place `v₃` with
  Frobenius `(z,1)`, its Kummer character, and local cup vanishing.
  Cited: Neukirch ANT (Chebotarev, ray class fields, Artin reciprocity). -/
  thirdRay :
    ∀ (v : Fin 2 → Place) (χ : Fin 2 → KChar),
      Function.Injective v →
      (∀ i, ¬ aboveN (v i)) →
      (∀ i, exactOrderN (χ i)) →
      (∀ (i : Fin 2) (w : Place), ramSupp (χ i) w ↔ w = v i) →
      ∃ (v3 : Place) (χ3 : KChar),
        v3 ≠ v 0 ∧ v3 ≠ v 1 ∧
        ¬ aboveN v3 ∧
        exactOrderN χ3 ∧
        (∀ w : Place, ramSupp χ3 w ↔ w = v3) ∧
        cupVanishes (χ 0) χ3 ∧ cupVanishes χ3 (χ 0) ∧
        cupVanishes (χ 1) χ3 ∧ cupVanishes χ3 (χ 1)
  /-- Local Tate duality + global reciprocity: the triple Massey cocycle
  has exact order `N`. Cited: Neukirch ANT. -/
  masseyExact :
    ∀ (χ1 χ2 χ3 : KChar),
      exactOrderN χ1 → exactOrderN χ2 → exactOrderN χ3 →
      cupVanishes χ1 χ2 → cupVanishes χ1 χ3 → cupVanishes χ2 χ3 →
      masseyOrderN χ1 χ2 χ3

end SelmerCartanMotiveTowers
