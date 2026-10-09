import Mathlib.Data.ZMod.Basic
import Mathlib.Data.Finset.Basic
import Mathlib.Data.Finsupp.Basic
import Mathlib.Data.Nat.Prime.Basic
import Mathlib.RingTheory.Coprime.Basic
import Definitions.Def_typed_coordinates

namespace SelmerCartanMotiveTowers

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

/- LIMITATION (P1-4): The "support-functorial dg realization"
    `ρ_{S,ν}^{Mot,MR} : U^{rec}_{S,N_ν} → M^{Mot,MR}_{S,N_ν}` requires a
    differential graded algebra (DGA) foundation. Mathlib has no DGA
    structure (verified by grep: no `MaurerCartan`, no bundled DGA).
    The dg realization remains a background hypothesis in
    `WitnessBackground` (`crtRealization`, `crtRealizationIs`).
    If the M2 DGA construction is completed, it can be connected here. -/

end SelmerCartanMotiveTowers
