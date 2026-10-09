import Definitions.Def_classfield_background

namespace SelmerCartanMotiveTowers

/-- Solution for Theorem 6.5 (`P1L-thm:ray-class-primitive`), Strategy A.

Proof assembly (mirrors the paper's §6 proof structure):
- `bg.firstTwoRays` gives the first two places/characters (Kummer + ray class fields + reciprocity).
- `bg.heisenbergLift` applied to that data gives the Heisenberg lift (cup product = obstruction).
- `bg.thirdRay` gives the third place `v₃` (Chebotarev + ray class fields) with local cup vanishing.
- `bg.masseyExact` gives the exact-order-`N` Massey cocycle (local Tate duality + reciprocity).
- The witnesses `v : Fin 3 → Place`, `χ : Fin 3 → KChar` are assembled from the three
  pairs; each conjunct is discharged by `fin_cases` + the corresponding input. -/
theorem sol_thm_ray_class_primitive (bg : ClassFieldBackground) :
    ∃ (v : Fin 3 → bg.Place) (χ : Fin 3 → bg.KChar),
      Function.Injective v ∧
      (∀ i, ¬ bg.aboveN (v i)) ∧
      (∀ i, bg.exactOrderN (χ i)) ∧
      (∀ (i : Fin 3) (w : bg.Place), bg.ramSupp (χ i) w ↔ w = v i) ∧
      (∀ i j : Fin 3, i ≠ j → bg.cupVanishes (χ i) (χ j)) ∧
      bg.heisLift (χ 0) (χ 1) ∧
      bg.masseyOrderN (χ 0) (χ 1) (χ 2) := by
  obtain ⟨v2, χ2, hv, habove, hord, hram, hcup01, hcup10⟩ := bg.firstTwoRays
  have hHeis := bg.heisenbergLift v2 χ2 hv habove hord hram hcup01
  obtain ⟨v3, χ3, hne0, hne1, habove3, hord3, hram3, hcup03, hcup30, hcup13, hcup31⟩ :=
    bg.thirdRay v2 χ2 hv habove hord hram
  have hMass := bg.masseyExact (χ2 0) (χ2 1) χ3 (hord 0) (hord 1) hord3 hcup01 hcup03 hcup13
  have h01 : v2 0 ≠ v2 1 := fun h => (by decide : (0 : Fin 2) ≠ 1) (hv h)
  have h02 : v2 0 ≠ v3 := hne0.symm
  have h12 : v2 1 ≠ v3 := hne1.symm
  refine ⟨(![v2 0, v2 1, v3] : Fin 3 → bg.Place),
          (![χ2 0, χ2 1, χ3] : Fin 3 → bg.KChar), ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · -- (1) the three places are distinct
    intro i j hij
    fin_cases i <;> fin_cases j <;> simp_all
  · -- (2) none lies above N
    intro i
    fin_cases i <;> simp_all
  · -- (3) each character has exact order N
    intro i
    fin_cases i <;> simp_all
  · -- (4) ramification support is exactly the singleton {vᵢ}
    intro i w
    fin_cases i <;> simp_all
  · -- (5) all pairwise cup classes vanish
    intro i j hij
    fin_cases i <;> fin_cases j <;> simp_all
  · -- (6) the Heisenberg lift for the first pair
    simpa using hHeis
  · -- (7) the triple Massey cocycle has exact order N
    simpa using hMass

end SelmerCartanMotiveTowers
