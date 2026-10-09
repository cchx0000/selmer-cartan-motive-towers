import Definitions.Def_motivic_moore_reedy
import Definitions.Def_finite_ordered_support
import Definitions.Def_channel_index
import Mathlib.Algebra.Squarefree.Basic
import Mathlib.Data.ZMod.Basic

namespace SelmerCartanMotiveTowers

/-- Dirac delta at `c` has exact additive order `N` in the product.
The `ℤ` component is `0`, so the order comes from the `ZMod N` function. -/
theorem dirac_order (S : finite_ordered_support) (N : Nat) (hN1 : 1 < N)
    (c : channel_index S) :
    addOrderOf ((Function.update (0 : channel_index S → ZMod N) c 1, (0 : ℤ)) :
      (channel_index S → ZMod N) × ℤ) = N := by
  have hNpos : 0 < N := by omega
  -- Order of the function component
  have hord : addOrderOf (Function.update (0 : channel_index S → ZMod N) c 1) = N := by
    rw [addOrderOf_eq_iff hNpos]
    refine ⟨?_, ?_⟩
    · funext i
      simp only [Pi.smul_apply, Pi.zero_apply]
      by_cases hic : i = c
      · subst hic; rw [Function.update_self]; simp
      · rw [Function.update_of_ne hic]; simp
    · intro k hkl hk0 hcontra
      have heval : ((k • ((Function.update (0 : channel_index S → ZMod N) c 1 : channel_index S → ZMod N))) c) = 0 := by
        rw [hcontra]; rfl
      rw [Pi.smul_apply, Function.update_self] at heval
      simp at heval
      have hdvd : N ∣ k := by
        have h' : (k : ZMod N) = ((0 : Nat) : ZMod N) := by simpa using heval
        rw [ZMod.natCast_eq_natCast_iff] at h'
        exact (Nat.modEq_zero_iff_dvd).mp h'
      have hle : N ≤ k := Nat.le_of_dvd hk0 hdvd
      omega
  -- Transfer to the pair: (f, 0) has same order as f
  rw [addOrderOf_eq_iff hNpos]
  refine ⟨?_, ?_⟩
  · -- N • (f, 0) = (0, 0)
    have hNf : N • (Function.update (0 : channel_index S → ZMod N) c 1 :
        channel_index S → ZMod N) = 0 := by
      funext i
      simp only [Pi.smul_apply, Pi.zero_apply]
      by_cases hic : i = c
      · subst hic; rw [Function.update_self]; simp [ZMod.natCast_self]
      · rw [Function.update_of_ne hic]; simp
    apply Prod.ext
    · -- First component: N • f = 0
      simpa using hNf
    · -- Second component: N • (0:ℤ) = 0
      simp
  · -- Minimality
    intro k hkl hk0 hcontra
    have hfst : k • ((Function.update (0 : channel_index S → ZMod N) c 1 : channel_index S → ZMod N)) = 0 := by
      have h2 := congrArg Prod.fst hcontra
      simpa using h2
    have hdvd : N ∣ k := by
      have h1 : addOrderOf (Function.update (0 : channel_index S → ZMod N) c 1) ≠ 0 := by
        rw [hord]; omega
      have h2 := addOrderOf_dvd_of_nsmul_eq_zero hfst
      rw [hord] at h2; exact h2
    have hle : N ≤ k := Nat.le_of_dvd hk0 hdvd
    omega

/-- Dirac delta chanMap is injective. -/
theorem dirac_injective (S : finite_ordered_support) (N : Nat) (hN1 : 1 < N) :
    Function.Injective (fun c : channel_index S =>
      (Function.update (0 : channel_index S → ZMod N) c 1, (0 : ℤ))) := by
  have hNT : Nontrivial (ZMod N) := by
    rw [ZMod.nontrivial_iff]; omega
  intro a b h
  have h1 : Function.update (0 : channel_index S → ZMod N) a 1 =
      Function.update (0 : channel_index S → ZMod N) b 1 :=
    congrArg Prod.fst h
  have ha : Function.update (0 : channel_index S → ZMod N) a 1 a = 1 :=
    Function.update_self a 1 _
  have h2 : Function.update (0 : channel_index S → ZMod N) b 1 a = 1 := by
    rw [← h1]; exact ha
  by_contra hne
  rw [Function.update_of_ne hne] at h2
  simp at h2

/-- Solution for Theorem 19.6 (`thm_channel_complete_realization`), M6.

The paper constructs the dg realization with seven properties. We model:
- `Source` as `ℕ → Bool` (Boolean skeleton);
- `M.carrier` as `(channel_index S → ZMod N) × ℤ`;
- `M.corrAlgebra` as `ZMod N`;
- `chanMap` as Dirac delta (injective, order `N` by `dirac_order`);
- `ρ` from channel support data (not constant);
- `delMap (f, z) = (f, 0)` (idempotent).

REVISION NOTE (P1-2 deep, 2026-10-09): See theorem file.
LIMITATIONS: See theorem file.
-/
theorem sol_thm_channel_complete_realization
    (S : finite_ordered_support) (N : Nat) (hNodd : Odd N) (hNsf : Squarefree N)
    (hN1 : 1 < N)
    : ∃ (Source : Type) (M : motivic_moore_reedy) (hAdd : AddCommGroup M.carrier)
        (ρ : Source → M.carrier)
        (chanMap : channel_index S → M.carrier)
        (delMap : M.carrier → M.carrier),
        M.support = S ∧ M.coeffOrder = N ∧
        Nonempty Source ∧ Nontrivial M.carrier ∧ Nontrivial M.corrAlgebra ∧
        Function.Injective chanMap ∧
        (∀ c : channel_index S, @addOrderOf M.carrier hAdd.toAddMonoid (chanMap c) = N) ∧
        (∀ x, delMap (delMap x) = delMap x) := by
  have hNT : Nontrivial (ZMod N) := by
    rw [ZMod.nontrivial_iff]; omega
  refine ⟨ℕ → Bool,
          { support := S, coeffOrder := N, coeffOrder_odd := hNodd,
            coeffOrder_squarefree := hNsf,
            carrier := (channel_index S → ZMod N) × ℤ,
            corrAlgebra := ZMod N },
          inferInstance,
          fun f => (fun c => if c.supp ⊆ S.primes.filter (fun p => f p) then 1 else 0, 0),
          fun c => (Function.update (0 : channel_index S → ZMod N) c 1, 0),
          fun p => (p.1, 0),
          rfl, rfl,
          ⟨fun _ => false⟩,
          ⟨(0, 0), (0, 1), by simp⟩,
          hNT,
          dirac_injective S N hN1,
          fun c => dirac_order S N hN1 c,
          fun x => by simp⟩

end SelmerCartanMotiveTowers
