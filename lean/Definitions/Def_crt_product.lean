import Mathlib.Data.ZMod.Basic
import Mathlib.Data.ZMod.QuotientRing
import Mathlib.Data.Finset.Basic
import Mathlib.Data.Finsupp.Basic
import Mathlib.Data.Nat.Prime.Basic
import Mathlib.RingTheory.Coprime.Basic
import Definitions.Def_typed_coordinates

namespace SelmerCartanMotiveTowers

open scoped Function

/-- The coefficient modulus `N_ν = ∏_{p ∈ supp ν} p^{ν_p}` (paper §28,
`P2M-thm:prime-power-all-support-comparison`).
The CRT content is that the `p^{ν_p}` are pairwise coprime (see
`crtModulus_pairwise_coprime` below), so `ZMod N_ν` is the CRT product
of the p-primary lines. -/
def crtModulus (ν : coefficient_exponent) : ℕ :=
  ν.val.support.prod (fun p => p.val ^ ν.val p)

/-- Distinct odd primes give coprime prime powers. -/
theorem ppow_coprime {p q : ℕ} {a b : ℕ}
    (hp : p.Prime) (hq : q.Prime) (hne : p ≠ q) :
    Nat.Coprime (p ^ a) (q ^ b) :=
  ((Nat.coprime_primes hp hq).mpr hne).pow a b

/-- The prime-power factors are pairwise coprime on the support.
    This is the CRT hypothesis: the p-primary lines have pairwise coprime
    orders, so their direct sum is cyclic of order `N_ν`. -/
theorem crtModulus_pairwise_coprime (ν : coefficient_exponent) :
    Set.Pairwise (↑ν.val.support : Set { p : ℕ // p.Prime ∧ p ≠ 2 })
      (fun p q => Nat.Coprime (p.val ^ ν.val p) (q.val ^ ν.val q)) := by
  intro p hp q hq hne
  apply ppow_coprime p.2.1 q.2.1
  intro h
  apply hne
  exact Subtype.ext h

/-- The CRT product line: `L^{conf}_ν = ZMod N_ν` (concrete).
    By the CRT (pairwise coprime moduli), this is the direct sum of the
    p-primary lines `ZMod (p^{ν_p})`. -/
abbrev crtLine (ν : coefficient_exponent) : Type :=
  ZMod (crtModulus ν)

/-- The generator `1` has exact order `N_ν`
    (paper: "exact additive order `N_ν`", property (i)). -/
theorem crtLine_order (ν : coefficient_exponent) :
    addOrderOf (1 : crtLine ν) = crtModulus ν :=
  ZMod.addOrderOf_one (crtModulus ν)

/-- Binary CRT building block (from Mathlib): `ZMod (m*n) ≃+* ZMod m × ZMod n`
    for coprime `m n`. The finite CRT is iteration of this. -/
def crtBinary {m n : ℕ} (h : m.Coprime n) :
    ZMod (m * n) ≃+* ZMod m × ZMod n :=
  ZMod.chineseRemainder h

/-- p-power reduction: `ZMod (p^a) →+* ZMod (p^b)` for `b ≤ a`
    (paper: "coefficient reductions `p^a ↠ p^b`", property (iii)).
    This is the concrete `red_{ν,μ}` on p-primary components. -/
def ppowerRed {p a b : ℕ} (h : b ≤ a) : ZMod (p ^ a) →+* ZMod (p ^ b) :=
  ZMod.castHom (pow_dvd_pow p h) (ZMod (p ^ b))

/-- p-power reductions compose: `red_{c≤b} ∘ red_{b≤a} = red_{c≤a}`
    (paper property (iii): the reductions form a compatible system).
    Proof: ring homomorphisms out of `ZMod (p^a)` are unique
    (`ZMod.subsingleton_ringHom`), so the two sides agree. -/
theorem ppowerRed_comp {p a b c : ℕ} (h₁ : b ≤ a) (h₂ : c ≤ b) :
    (ppowerRed (p := p) h₂).comp (ppowerRed (p := p) h₁)
      = ppowerRed (p := p) (h₂.trans h₁) :=
  Subsingleton.elim _ _

/-- A concrete Moore presentation: the data of a Moore class `B` of exact
    order `N` (paper: "canonical pointed universal Moore presentation
    `ℤ C_ν →[N_ν] ℤ B_ν`", with `dC_ν = N_ν • B_ν` and `ord[B_ν] = N_ν`).
    The antecedent `C` and differential are part of the 2-term complex;
    here we record the class `B` and its exact order, which is what the
    comparison theorem consumes. -/
structure MoorePresentation (N : ℕ) where
  B : ZMod N
  hB : addOrderOf B = N

/-- The CRT product line carries a canonical Moore presentation with
    `B_ν = 1` of exact order `N_ν` (paper: "has a canonical pointed
    universal Moore presentation"). -/
def crtMoorePresentation (ν : coefficient_exponent) :
    MoorePresentation (crtModulus ν) :=
  { B := 1
    hB := crtLine_order ν }

/-! ## Finite CRT product isomorphism (P1-4 revision, verifier feedback)

The binary CRT (`crtBinary` / `ZMod.chineseRemainder`) iterates to a ring
isomorphism between `ZMod N_ν` and the product of the p-primary lines.
We use Mathlib's general finite CRT `ZMod.prodEquivPi`
(`Mathlib/Data/ZMod/QuotientRing.lean`), which is itself proved by
iterating the binary case. -/

/-- The coefficient modulus as a product over the coerced support:
    `N_ν = ∏_{p : ↥(supp ν)} p^{ν_p}`. This aligns `crtModulus` with the
    product Mathlib's `ZMod.prodEquivPi` takes. -/
theorem crtModulus_eq_prod_coe (ν : coefficient_exponent) :
    crtModulus ν = ∏ p : ↥(ν.val.support), (p.val.val ^ ν.val p.val) := by
  have h := Finset.prod_coe_sort (ν.val.support)
    (fun q : { p : ℕ // p.Prime ∧ p ≠ 2 } => q.val ^ ν.val q)
  show ν.val.support.prod (fun p => p.val ^ ν.val p) =
    ∏ p : ↥(ν.val.support),
      (fun q : { p : ℕ // p.Prime ∧ p ≠ 2 } => q.val ^ ν.val q) p.val
  rw [h]

/-- The prime-power factors are pairwise coprime, in the form consumed by
    Mathlib's `ZMod.prodEquivPi`. -/
theorem crtPairwiseCoprime (ν : coefficient_exponent) :
    Pairwise
      (Nat.Coprime on fun p : ↥(ν.val.support) => (p.val.val ^ ν.val p.val)) := by
  intro x y hne
  apply ppow_coprime (x.val).2.1 (y.val).2.1
  intro h
  apply hne
  exact Subtype.ext (Subtype.ext h)

/-- The **finite CRT product isomorphism**
    `ZMod N_ν ≃+* Π_{p ∈ supp ν} ZMod (p^{ν_p})`
    (paper `P2M-thm:prime-power-all-support-comparison`: "the CRT product
    of the p-primary lines"). Pointed: it sends the generator `1` to the
    tuple `(1, 1, …)` (see `crtProductEquiv_one`). -/
noncomputable def crtProductEquiv (ν : coefficient_exponent) :
    ZMod (crtModulus ν) ≃+*
      Π p : ↥(ν.val.support), ZMod (p.val.val ^ ν.val p.val) :=
  (ZMod.ringEquivCongr (crtModulus_eq_prod_coe ν)).trans
    (ZMod.prodEquivPi _ (crtPairwiseCoprime ν))

/-- Point preservation: the CRT isomorphism sends the generator `1` of
    `ZMod N_ν` to the tuple of generators `(1, 1, …)`. This is the
    "pointed" part of the comparison (automatic for a `RingEquiv`). -/
theorem crtProductEquiv_one (ν : coefficient_exponent) :
    crtProductEquiv ν 1 = 1 :=
  map_one _

/-- Evaluation at a support point as a ring homomorphism
    (used for the exchange diagram below). -/
def evalAtCoe {P : Type*} (M : P → Type*) [∀ p, Ring (M p)] (s : Finset P)
    (p : ↥s) : (Π q : ↥s, M q.val) →+* M p.val where
  toFun x := x p
  map_one' := rfl
  map_mul' _ _ := rfl
  map_zero' := rfl
  map_add' _ _ := rfl

/-- **Generator/coefficient exchange diagram**: the `p`-component of the
    CRT isomorphism is the actual p-primary reduction
    `ZMod N_ν →+* ZMod (p^{ν_p})` (the canonical `ZMod.castHom`), not just
    an abstractly existing `RingHom`. Proof: both sides are ring
    homomorphisms out of `ZMod N_ν`, hence equal
    (`ZMod.subsingleton_ringHom`). -/
theorem crtProductEquiv_apply (ν : coefficient_exponent) (p : ↥(ν.val.support))
    (x : ZMod (crtModulus ν)) :
    crtProductEquiv ν x p
      = ZMod.castHom (Finset.dvd_prod_of_mem (fun q => q.val ^ ν.val q) p.property)
          (ZMod (p.val.val ^ ν.val p.val)) x := by
  have heq := Subsingleton.elim
    ((evalAtCoe (fun q => ZMod (q.val ^ ν.val q)) _ p).comp
      (crtProductEquiv ν).toRingHom)
    (ZMod.castHom (Finset.dvd_prod_of_mem (fun q => q.val ^ ν.val q) p.property)
      (ZMod (p.val.val ^ ν.val p.val)))
  exact DFunLike.congr_fun heq x

/- LIMITATION (P1-4): Two pieces of the paper's Moore presentation are not
    yet constructed here, and are honestly labeled as such.
    (a) The "support-functorial dg realization"
    `ρ_{S,ν}^{Mot,MR} : U^{rec}_{S,N_ν} → M^{Mot,MR}_{S,N_ν}` requires a
    differential graded algebra (DGA) foundation. Mathlib has no DGA
    structure (verified by grep: no `MaurerCartan`, no bundled DGA).
    The dg realization remains a background hypothesis in
    `WitnessBackground` (`crtRealization`, `crtRealizationIs`).
    If the M2 DGA construction is completed, it can be connected here.
    (b) The integral 2-term complex `ℤ C_ν →[N_ν] ℤ B_ν` (the integral
    chain `C`, the differential `d`, and the quotient identification
    `coker(d) ≃+* ZMod N_ν`): `MoorePresentation` records the Moore class
    `B` and its exact order, which is what the comparison theorem consumes,
    but the integral antecedent `C` and the differential are not built.
    What IS now concrete (this revision): the finite CRT product ring
    isomorphism `crtProductEquiv` (pointed, `1 ↦ 1`), the actual p-primary
    reductions with their composition law (`ppowerRed_comp`) and the
    generator/coefficient exchange diagram (`crtProductEquiv_apply`). -/

end SelmerCartanMotiveTowers
