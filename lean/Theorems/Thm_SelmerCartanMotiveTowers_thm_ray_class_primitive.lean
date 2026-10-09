import Definitions.Def_classfield_background
import Solutions.Sol_thm_ray_class_primitive

namespace SelmerCartanMotiveTowers

/-- Primitive ray-class three-prime construction (Theorem 6.5,
`P1L-thm:ray-class-primitive`), REVISED per Strategy A (axiomatic skeleton).

Assuming the class-field-theoretic background package
(`ClassFieldBackground`: Kummer theory, ray class field existence, Chebotarev
density, local Tate duality, global reciprocity — all cited to Neukirch's
*Algebraic Number Theory*; the lemma-level conclusions `first-two-rays` and
`ray-heisenberg-lift` recorded as inputs), there exist three distinct finite
places `v₁, v₂, v₃` not above `N` and order-`N` tame Kummer characters
`χ₁, χ₂, χ₃` with ramification support `S(χᵢ) = {vᵢ}`, such that all three
pairwise cup classes vanish in `H²(F, A_N)`, the first two admit a fixed
surjective Heisenberg lift, and the pointed triple-Massey cocycle has exact
additive order `N`.

REVISION NOTE (2026-10-09): The first draft was FALSE as stated — it
universally quantified over arbitrary `Place`/`KChar` types and unconstrained
predicates while the conclusion required those predicates to hold
(machine-verified countermodel: all predicates constantly `False`). This
revision takes the arithmetic background as an explicit hypothesis, which
rules out the degenerate model and matches the paper's proof structure
(§6 uses only Kummer theory, ray class fields, local duality, Chebotarev). -/
theorem thm_ray_class_primitive (bg : ClassFieldBackground) :
    ∃ (v : Fin 3 → bg.Place) (χ : Fin 3 → bg.KChar),
      Function.Injective v ∧
      (∀ i, ¬ bg.aboveN (v i)) ∧
      (∀ i, bg.exactOrderN (χ i)) ∧
      (∀ (i : Fin 3) (w : bg.Place), bg.ramSupp (χ i) w ↔ w = v i) ∧
      (∀ i j : Fin 3, i ≠ j → bg.cupVanishes (χ i) (χ j)) ∧
      bg.heisLift (χ 0) (χ 1) ∧
      bg.masseyOrderN (χ 0) (χ 1) (χ 2) :=
  SelmerCartanMotiveTowers.sol_thm_ray_class_primitive bg

end SelmerCartanMotiveTowers
