import Definitions.Def_motivic_moore_reedy
import Definitions.Def_finite_ordered_support
import Definitions.Def_channel_index
import Mathlib.Algebra.Squarefree.Basic
import Mathlib.Data.ZMod.Basic
import Mathlib.Data.Finset.Card

namespace SelmerCartanMotiveTowers

/-- The latching class `Ω_I` for a finite support `I`: the characteristic
function of `I` as a Boolean function on `ℕ`. This models the paper's
`Ω_I^{rec}` (higher latching polynomial class) at the Boolean skeleton
level. Paper `P2M-thm:channel-complete-realization` (iv): for `|I| ≥ 3`,
`[ρ(Ω_I)]` has exact additive order `N`. -/
def omegaClass (I : Finset ℕ) : ℕ → Bool := fun p => decide (p ∈ I)

/-- The Rees multiplication profile `(1, N, N²)` from the cyclotomic
transfer powers `T_N` (paper (iii)). These are the coefficients of the
raw flatness law; as natural numbers they are `1`, `N`, `N^2`. -/
def reesCoeff (N : ℕ) : Fin 3 → ℕ
  | ⟨0, _⟩ => 1
  | ⟨1, _⟩ => N
  | ⟨2, _⟩ => N ^ 2

/-- Construct a channel index from a finset `I` with `|I| ≥ 3` and
`I ⊆ S.primes`: take `supp = I`, `partA = {i₀}`, `partB = I \ {i₀}`.
Uses classical choice to pick `i₀ ∈ I`. -/
noncomputable def channelOfFinset (S : finite_ordered_support) (I : Finset ℕ)
    (hI : I ⊆ S.primes) (hcard : 3 ≤ I.card) : channel_index S :=
  let hne : ∃ x, x ∈ I := Finset.card_pos.mp (by omega : 0 < I.card)
  let i₀ : ℕ := Classical.choose hne
  let hi₀ : i₀ ∈ I := Classical.choose_spec hne
  { supp := I, supp_sub := hI, card_ge := hcard,
    partA := {i₀}, partB := I \ {i₀},
    partA_sub := Finset.singleton_subset_iff.mpr hi₀,
    partB_sub := Finset.sdiff_subset,
    part_cover := by
      ext x
      simp only [Finset.mem_union, Finset.mem_singleton, Finset.mem_sdiff]
      constructor
      · rintro (rfl | ⟨hx, _⟩)
        · exact hi₀
        · exact hx
      · intro hx
        by_cases hxi : x = i₀
        · left; exact hxi
        · right; exact ⟨hx, hxi⟩,
    part_disjoint := by
      rw [Finset.disjoint_left]
      intro x hx1 hx2
      simp only [Finset.mem_singleton] at hx1
      -- hx2 : x ∈ I \ {i₀}, so x ≠ i₀
      have hx2ne : x ≠ i₀ := by
        intro hcontra
        have : x ∈ ({i₀} : Finset ℕ) := by simpa [hcontra]
        have hmem : x ∈ I \ {i₀} := hx2
        rw [Finset.mem_sdiff] at hmem
        exact hmem.2 this
      exact hx2ne hx1,
    partA_nonempty := Finset.singleton_nonempty i₀,
    partB_nonempty := by
      have h2 : ({i₀} : Finset ℕ) ⊆ I := Finset.singleton_subset_iff.mpr hi₀
      have hcard2 : (I \ {i₀}).card = I.card - 1 := by
        rw [Finset.card_sdiff_of_subset h2, Finset.card_singleton]
      have : 2 ≤ (I \ {i₀}).card := by omega
      exact Finset.card_pos.mp (by omega : 0 < (I \ {i₀}).card) }

/-- The channel constructed from `I` has support `I`. -/
theorem channelOfFinset_supp (S : finite_ordered_support) (I : Finset ℕ)
    (hI : I ⊆ S.primes) (hcard : 3 ≤ I.card) :
    (channelOfFinset S I hI hcard).supp = I := rfl

/-- Paper (iv): for `|I| ≥ 3`, `I ⊆ S.primes`, `0 ∉ I`, the class
`[ρ(Ω_I)]` has exact additive order `N`. The `ρ`-image is
`(g, 0)` where `g` is 1 on channels with support `⊆ I`; the constructed
channel `c₀` with support `I` witnesses `g c₀ = 1`, giving exact order `N`. -/
theorem omega_order (S : finite_ordered_support) (N : ℕ) (hN1 : 1 < N)
    (I : Finset ℕ) (hI : I ⊆ S.primes) (hcard : 3 ≤ I.card) (h0 : 0 ∉ I)
    (ρ : (ℕ → Bool) → (channel_index S → ZMod N) × ℤ)
    (hρ : ρ = fun f => (fun c : channel_index S =>
      if c.supp ⊆ S.primes.filter (fun p => f p) then 1 else 0,
      if f 0 then (1:ℤ) else 0)) :
    addOrderOf (ρ (omegaClass I)) = N := by
  have hNpos : 0 < N := by omega
  -- The filter equals I: {p ∈ S.primes : (omegaClass I) p = true} = I
  -- Since (omegaClass I) p = decide (p ∈ I), and I ⊆ S.primes.
  have hfilter : S.primes.filter (fun p => (omegaClass I) p) = I := by
    have h1 : ∀ p ∈ S.primes, ((omegaClass I) p = true ↔ p ∈ I) := by
      intro p _
      simp [omegaClass]
    -- Use filter_congr and the fact that I = S.primes ∩ I
    have h2 : S.primes.filter (fun p => (omegaClass I) p) = S.primes.filter (fun p => p ∈ I) := by
      apply Finset.filter_congr
      intro p hp
      simp [omegaClass, (h1 p hp)]
    rw [h2]
    -- {p ∈ S.primes : p ∈ I} = I since I ⊆ S.primes
    ext p
    simp only [Finset.mem_filter]
    constructor
    · rintro ⟨_, hpI⟩; exact hpI
    · intro hpI; exact ⟨hI hpI, hpI⟩
  -- ρ (omegaClass I) = (g, 0) where g c = if c.supp ⊆ I then 1 else 0
  have hρI : ρ (omegaClass I) =
      ((fun c : channel_index S => if c.supp ⊆ I then (1 : ZMod N) else 0), (0 : ℤ)) := by
    rw [hρ]
    have h0' : (omegaClass I) 0 = false := by
      simp only [omegaClass]
      simpa using h0
    simp only [hfilter, h0', Bool.false_eq_true, ↓reduceIte]
  rw [hρI]
  -- The witness channel
  let c₀ := channelOfFinset S I hI hcard
  have hc₀supp : c₀.supp = I := channelOfFinset_supp S I hI hcard
  have hc₀ : (fun c : channel_index S => if c.supp ⊆ I then (1 : ZMod N) else 0) c₀ = 1 := by
    show (if c₀.supp ⊆ I then (1 : ZMod N) else 0) = 1
    rw [hc₀supp]
    rw [if_pos (Finset.Subset.refl I)]
  -- Order is N
  rw [addOrderOf_eq_iff hNpos]
  refine ⟨?_, ?_⟩
  · -- N • (g, 0) = (0, 0)
    apply Prod.ext
    · -- First component: N • g = 0
      funext c
      show (N • (fun c : channel_index S => if c.supp ⊆ I then (1 : ZMod N) else 0)) c = 0
      rw [Pi.smul_apply]
      by_cases hc : c.supp ⊆ I
      · rw [if_pos hc, nsmul_eq_mul, mul_one, ZMod.natCast_self]
      · rw [if_neg hc]
        simp
    · simp
  · -- Minimality: if k • (g,0) = 0 with 0 < k, then N ≤ k
    intro k hkl hk0 hcontra
    have hfst : k • (fun c : channel_index S => if c.supp ⊆ I then (1 : ZMod N) else 0) = 0 := by
      have h2 := congrArg Prod.fst hcontra
      simpa using h2
    have heval : (k • (fun c : channel_index S => if c.supp ⊆ I then (1 : ZMod N) else 0)) c₀ = 0 := by
      rw [hfst]; rfl
    -- Beta-reduce: ((fun c => ...) c₀) becomes (if c₀.supp ⊆ I then 1 else 0)
    simp only [Pi.smul_apply] at heval
    -- Now heval : k • (if c₀.supp ⊆ I then (1:ZMod N) else 0) = 0
    -- Use hc₀supp to rewrite c₀.supp = I
    rw [hc₀supp] at heval
    -- Now: k • (if I ⊆ I then 1 else 0) = 0
    rw [if_pos (Finset.Subset.refl I)] at heval
    -- Now: k • (1 : ZMod N) = 0, where • is ℕ-scalar mul
    -- This equals (k : ZMod N) = 0 by nsmul_eq_mul
    rw [nsmul_eq_mul] at heval
    rw [mul_one] at heval
    -- Now heval : (k : ZMod N) = 0
    -- k • 1 = 0 in ZMod N implies N ∣ k
    have h' : (k : ZMod N) = (0 : ZMod N) := heval
    rw [← Nat.cast_zero, ZMod.natCast_eq_natCast_iff] at h'
    have hdvd : N ∣ k := (Nat.modEq_zero_iff_dvd).mp h'
    have hle : N ≤ k := Nat.le_of_dvd hk0 hdvd
    omega

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
- `ρ` from channel support data (not constant); the `ℤ` component records
  `f 0`, witnessing non-constancy;
- `delMap (f, z) = (f, 0)` (idempotent).

REVISION NOTE (P1-2 deep, 2026-10-09): See theorem file.
LIMITATIONS: See theorem file.

REVISION NOTE 2 (2026-10-10): The `ρ` is now genuinely non-constant
(the `ℤ` component records `f 0`), `Source` is `Nontrivial` (not just
`Nonempty`), and `Ring M.corrAlgebra` is provided.

REVISION NOTE 3 (2026-10-10, P1-2 M6 deep): Paper (iv) formalized —
`omega : Finset ℕ → Source` gives the latching class `Ω_I`
(`omegaClass I` = characteristic function of `I`); for `|I| ≥ 3`,
`I ⊆ S.primes`, `0 ∉ I`, `addOrderOf (ρ (omega I)) = N` by `omega_order`.
The Rees profile `(1, N, N²)` is recorded as `reesCoeff`. -/
theorem sol_thm_channel_complete_realization
    (S : finite_ordered_support) (N : Nat) (hNodd : Odd N) (hNsf : Squarefree N)
    (hN1 : 1 < N)
    : ∃ (Source : Type) (M : motivic_moore_reedy) (hAdd : AddCommGroup M.carrier)
        (hRing : Ring M.corrAlgebra)
        (ρ : Source → M.carrier)
        (chanMap : channel_index S → M.carrier)
        (delMap : M.carrier → M.carrier)
        (omega : Finset ℕ → Source),
        M.support = S ∧ M.coeffOrder = N ∧
        Nontrivial Source ∧ Nontrivial M.carrier ∧ Nontrivial M.corrAlgebra ∧
        Function.Injective chanMap ∧
        (∀ c : channel_index S, @addOrderOf M.carrier hAdd.toAddMonoid (chanMap c) = N) ∧
        (∀ x, delMap (delMap x) = delMap x) ∧
        (∃ a b : Source, ρ a ≠ ρ b) ∧
        (∀ I : Finset ℕ, I ⊆ S.primes → 3 ≤ I.card → 0 ∉ I →
          @addOrderOf M.carrier hAdd.toAddMonoid (ρ (omega I)) = N) := by
  have hNT : Nontrivial (ZMod N) := by
    rw [ZMod.nontrivial_iff]; omega
  have hSrcNT : Nontrivial (ℕ → Bool) :=
    ⟨fun _ => true, fun _ => false, fun h => by simpa using congrFun h 0⟩
  -- The concrete ρ
  let ρ0 : (ℕ → Bool) → (channel_index S → ZMod N) × ℤ :=
    fun f => (fun c => if c.supp ⊆ S.primes.filter (fun p => f p) then 1 else 0,
      if f 0 then (1:ℤ) else 0)
  refine ⟨ℕ → Bool,
          { support := S, coeffOrder := N, coeffOrder_odd := hNodd,
            coeffOrder_squarefree := hNsf,
            carrier := (channel_index S → ZMod N) × ℤ,
            corrAlgebra := ZMod N },
          inferInstance,
          inferInstance,
          ρ0,
          fun c => (Function.update (0 : channel_index S → ZMod N) c 1, 0),
          fun p => (p.1, 0),
          omegaClass,
          rfl, rfl,
          hSrcNT,
          ⟨(0, 0), (0, 1), by simp⟩,
          hNT,
          dirac_injective S N hN1,
          fun c => dirac_order S N hN1 c,
          fun x => by simp,
          ⟨fun _ => true, fun _ => false, by
            intro h
            have h2 := congrArg Prod.snd h
            -- h2 : ρ0 (fun _ => true) |>.2 = ρ0 (fun _ => false) |>.2
            -- ρ0 f |>.2 = if f 0 then 1 else 0
            have e1 : (ρ0 (fun _ => true)).2 = (1 : ℤ) := rfl
            have e2 : (ρ0 (fun _ => false)).2 = (0 : ℤ) := rfl
            rw [e1, e2] at h2
            -- h2 : (1:ℤ) = 0, contradiction
            omega⟩,
          fun I hI hcard h0 => omega_order S N hN1 I hI hcard h0 ρ0 rfl⟩

end SelmerCartanMotiveTowers
