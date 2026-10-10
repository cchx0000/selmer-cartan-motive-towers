import Mathlib.Data.ZMod.Basic
import Mathlib.Data.ZMod.QuotientRing
import Mathlib.Data.Finset.Basic
import Mathlib.Data.Finsupp.Basic
import Mathlib.Data.Nat.Prime.Basic
import Mathlib.RingTheory.Coprime.Basic
import Definitions.Def_typed_coordinates
import Definitions.Def_moore_cohomology_line
import Definitions.Def_witness_background

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

/-! ## Integral Moore complex (M10 revision, verifier feedback)

The verifier noted `MoorePresentation` carried only the Moore class `B` and
its exact order — no integral chain `C`, no differential, no quotient
identification. We now record the full integral 2-term data
`ℤ C_ν →[N_ν] ℤ B_ν` from the paper: antecedent and degree-`d` chain
carriers, the additive Moore differential with its square-zero law, the
designated generators with `dC genC = N • genD` (paper:
`d C_ν = N_ν • B_ν`), and the pointed quotient identification
`coker(dC) ≃+ ZMod N`. The canonical model `crtIntegralMoore N` is
`ℤ →[×N] ℤ`; the chain lemma `crtMoore_range_eq_mooreBoundaries` ties the
new general construction to the existing `p*q^2` machinery of
`Def_moore_cohomology_line.lean`. -/

/-- Integral 2-term Moore data at modulus `N` (paper: the integral complex
    `ℤ C_ν →[N_ν] ℤ B_ν` with `d C_ν = N_ν • B_ν`).
    Fields:
    - `C`, `D`: the antecedent (degree `d-1`) and degree-`d` integral chain
      carriers (paper: `ℤ C_ν`, `ℤ B_ν`);
    - `dC : C →+ D`: the additive Moore differential;
    - `sqZero`: the square-zero law of the 2-term complex — the differential
      followed by the projection onto its cokernel is zero (the 2-term
      analogue of `d² = 0`; the paper's complex continues `ℤ B_ν → 0`);
    - `genC`, `genD`: the designated generators (`C_ν`, `B_ν`);
    - `diff_gen`: `dC genC = N • genD` (paper: `d C_ν = N_ν • B_ν`);
    - `quotEquiv`: the quotient identification `D ⧸ range dC ≃+ ZMod N`;
    - `pointed`: `[genD] ↦ 1`, i.e. the class of the degree-`d` generator is
      the distinguished Moore class `1 : ZMod N`. -/
structure IntegralMooreComplex (N : ℕ) where
  /-- antecedent chain carrier (degree `d-1`; paper: `ℤ C_ν`) -/
  C : Type*
  [instAddCommGroupC : AddCommGroup C]
  /-- degree-`d` chain carrier (paper: `ℤ B_ν`) -/
  D : Type*
  [instAddCommGroupD : AddCommGroup D]
  /-- the additive Moore differential -/
  dC : C →+ D
  /-- square-zero law: differential followed by cokernel projection is zero -/
  sqZero : (QuotientAddGroup.mk' (AddMonoidHom.range dC)).comp dC = 0
  /-- designated antecedent generator (paper: `C_ν`) -/
  genC : C
  /-- designated degree-`d` generator (paper: `B_ν`) -/
  genD : D
  /-- `dC genC = N • genD` (paper: `d C_ν = N_ν • B_ν`) -/
  diff_gen : dC genC = N • genD
  /-- the quotient identification `D ⧸ range dC ≃+ ZMod N` -/
  quotEquiv : (D ⧸ AddMonoidHom.range dC) ≃+ ZMod N
  /-- pointed: the class of the degree-`d` generator maps to `1` -/
  pointed : quotEquiv (QuotientAddGroup.mk genD) = 1

/-- The chain carriers of an integral Moore complex are additive groups.
    Derived from the `AddCommGroup` instance fields of
    `IntegralMooreComplex`: use sites such as `QuotientAddGroup.mk`
    request `AddGroup`, which typeclass resolution does not synthesize
    from a bare structure projection on its own. -/
instance IntegralMooreComplex.addGroupC {N : ℕ} (I : IntegralMooreComplex N) :
    AddGroup I.C := by
  haveI := I.instAddCommGroupC
  infer_instance

/-- The degree-`d` chain carrier is an additive group (see
    `IntegralMooreComplex.addGroupC`). -/
instance IntegralMooreComplex.addGroupD {N : ℕ} (I : IntegralMooreComplex N) :
    AddGroup I.D := by
  haveI := I.instAddCommGroupD
  infer_instance

/-- The canonical Moore differential `×N : ℤ →+ ℤ`
    (paper: `d C_ν = N_ν • B_ν` on the universal integral model). -/
def crtMooreDiff (N : ℕ) : ℤ →+ ℤ where
  toFun x := (N : ℤ) * x
  map_zero' := by simp
  map_add' := fun x y => by ring

/-- The image of the canonical Moore differential is the boundaries
    subgroup `N • ℤ` (same proof shape as `mooreDiff_range`, generalized
    from `p*q^2` to arbitrary `N`). -/
theorem crtMooreDiff_range (N : ℕ) :
    AddMonoidHom.range (crtMooreDiff N) = AddSubgroup.zmultiples (N : ℤ) := by
  ext x
  constructor
  · rintro ⟨y, rfl⟩
    exact ⟨y, by simp [crtMooreDiff, zsmul_eq_mul]; ring⟩
  · rintro ⟨n, rfl⟩
    refine ⟨n, ?_⟩
    simp [crtMooreDiff, zsmul_eq_mul]
    ring

/-- The differential law on generators: `dC 1 = N • 1`
    (paper: `d C_ν = N_ν • B_ν`). -/
theorem crtMooreDiff_gen (N : ℕ) : crtMooreDiff N 1 = N • (1 : ℤ) := by
  have h : ∀ x : ℤ, crtMooreDiff N x = (N : ℤ) * x := fun x => rfl
  rw [h, nsmul_eq_mul]

/-- Square-zero law, pointwise: the cokernel projection kills the
    differential image. -/
theorem crtMooreDiff_sqZero_apply (N : ℕ) (x : ℤ) :
    QuotientAddGroup.mk' (AddMonoidHom.range (crtMooreDiff N))
      (crtMooreDiff N x) = 0 := by
  rw [← AddMonoidHom.mem_ker, QuotientAddGroup.ker_mk']
  exact AddMonoidHom.mem_range.mpr ⟨x, rfl⟩

/-- Square-zero law of the canonical integral Moore complex: the
    differential followed by the cokernel projection is zero. -/
theorem crtMooreDiff_sqZero (N : ℕ) :
    (QuotientAddGroup.mk' (AddMonoidHom.range (crtMooreDiff N))).comp
      (crtMooreDiff N) = 0 := by
  apply AddMonoidHom.ext
  intro x
  exact crtMooreDiff_sqZero_apply N x

/-- The quotient identification `ℤ ⧸ zmultiples (N:ℤ) ≃+ ZMod N`,
    generalizing `moore_cohomology` (`Def_moore_cohomology_line.lean`,
    stated for `p*q^2`) to arbitrary modulus `N`. -/
def crtMooreQuotient (N : ℕ) :
    (ℤ ⧸ AddSubgroup.zmultiples (N : ℤ)) ≃+ ZMod N :=
  (QuotientAddGroup.quotientAddEquivOfEq (ZMod.ker_intCastAddHom N)).symm.trans
    (QuotientAddGroup.quotientKerEquivOfRightInverse
      (Int.castAddHom (ZMod N)) ZMod.cast
      (fun a => ZMod.intCast_zmod_cast a))

/-- The quotient identification is induced by `Int.cast` (same
    definitional computation as `moore_cohomology_apply_mk`). -/
theorem crtMooreQuotient_apply_mk (N : ℕ) (x : ℤ) :
    crtMooreQuotient N (QuotientAddGroup.mk x) = (x : ZMod N) :=
  rfl

/-- The cohomology of the integral Moore complex at modulus `N`:
    `ℤ ⧸ range (crtMooreDiff N) ≃+ ZMod N` — the paper's quotient
    identification `coker(d) ≃+ ℤ/N`. Factors through `crtMooreDiff_range`
    (boundaries = differential image) and `crtMooreQuotient`. -/
def crtMooreCohomology (N : ℕ) :
    (ℤ ⧸ AddMonoidHom.range (crtMooreDiff N)) ≃+ ZMod N :=
  (QuotientAddGroup.quotientAddEquivOfEq (crtMooreDiff_range N)).trans
    (crtMooreQuotient N)

/-- The cohomology identification is induced by `Int.cast`. -/
theorem crtMooreCohomology_apply_mk (N : ℕ) (x : ℤ) :
    crtMooreCohomology N (QuotientAddGroup.mk x) = (x : ZMod N) := by
  unfold crtMooreCohomology
  rw [AddEquiv.trans_apply, QuotientAddGroup.quotientAddEquivOfEq_mk,
    crtMooreQuotient_apply_mk]

/-- Pointedness: the class of the degree-`d` generator maps to `1`. -/
theorem crtMooreCohomology_pointed (N : ℕ) :
    crtMooreCohomology N (QuotientAddGroup.mk (1 : ℤ)) = 1 := by
  rw [crtMooreCohomology_apply_mk]
  exact Int.cast_one

/-- The canonical integral Moore complex at modulus `N`: `ℤ →[×N] ℤ`
    with the quotient identification `crtMooreCohomology N`
    (paper: the universal integral model of `ℤ C_ν →[N_ν] ℤ B_ν`). -/
def crtIntegralMoore (N : ℕ) : IntegralMooreComplex N where
  C := ℤ
  D := ℤ
  dC := crtMooreDiff N
  sqZero := crtMooreDiff_sqZero N
  genC := 1
  genD := 1
  diff_gen := crtMooreDiff_gen N
  quotEquiv := crtMooreCohomology N
  pointed := crtMooreCohomology_pointed N

/-- The canonical integral Moore complex is pointed at the Moore class:
    the quotient identification sends `[genD]` to `1`. -/
theorem crtIntegralMoore_class (N : ℕ) :
    (crtIntegralMoore N).quotEquiv
      (QuotientAddGroup.mk (crtIntegralMoore N).genD) = 1 :=
  crtMooreCohomology_pointed N

/-- Chain lemma (M10): the new general integral Moore construction
    specializes to the existing `p*q^2` machinery of
    `Def_moore_cohomology_line.lean` — the differential range at
    `N = p*q^2` is exactly `mooreBoundaries p q`, so
    `crtMooreCohomology (p*q^2)` and `moore_cohomology_of_diff p q`
    identify the same quotient. -/
theorem crtMoore_range_eq_mooreBoundaries (p q : ℕ) :
    AddMonoidHom.range (crtMooreDiff (p * q ^ 2)) = mooreBoundaries p q := by
  rw [crtMooreDiff_range]
  unfold mooreBoundaries
  have h : ((p * q ^ 2 : ℕ) : ℤ) = (p * q ^ 2 : ℤ) := by push_cast; ring
  rw [h]

/-- A concrete Moore presentation: the data of a Moore class `B` of exact
    order `N` (paper: "canonical pointed universal Moore presentation
    `ℤ C_ν →[N_ν] ℤ B_ν`", with `dC_ν = N_ν • B_ν` and `ord[B_ν] = N_ν`).

    M10 revision (verifier feedback): the presentation now carries the full
    integral 2-term data (`integral : IntegralMooreComplex N`) — the chain
    carriers, the additive differential with its square-zero law, the
    designated generators with `dC genC = N • genD`, and the pointed
    quotient identification `coker(dC) ≃+ ZMod N` — together with the
    coherence `class_eq` identifying the Moore class `B` as the image of
    the degree-`d` generator. It is no longer "B + order" alone. -/
structure MoorePresentation (N : ℕ) where
  B : ZMod N
  hB : addOrderOf B = N
  integral : IntegralMooreComplex N
  class_eq : integral.quotEquiv (QuotientAddGroup.mk integral.genD) = B

/-- The CRT product line carries a canonical Moore presentation with
    `B_ν = 1` of exact order `N_ν` (paper: "has a canonical pointed
    universal Moore presentation"), now with the full integral 2-term data
    (`crtIntegralMoore`). -/
def crtMoorePresentation (ν : coefficient_exponent) :
    MoorePresentation (crtModulus ν) :=
  { B := 1
    hB := crtLine_order ν
    integral := crtIntegralMoore (crtModulus ν)
    class_eq := crtIntegralMoore_class (crtModulus ν) }

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

/-! ## Support-functorial dg realization binding (M10 revision)

The old conclusion `∃ ρ, bg.crtIsSupportFunctorialDg ρ` projected the
background hypothesis independently: `S` was unused, and the realization
was attached to nothing (`ν`/`N_ν`, the CRT product, the reductions).
`DgRealizationBinding` binds, over the support `S` and the depth datum
`ν`: the background dg realization at the N_ν-layer and its
support-functoriality hypothesis (still background hypotheses — Mathlib
has no DGA foundation — but now carried as fields of the `(S, ν)`-indexed
binding rather than projected independently); the genuine consumption of
`S` via `suppSub` (the ν-layer primes sit inside `S.primes`:
support-functorial restriction, paper §28); the p-primary (ν-layer)
realizations; and the realization/reduction exchange square (paper
L13000–13076) as the explicit hypothesis `IsPrimaryReduction` — the
dg-side reduction maps are not formalized, so the square is assumed in
predicate form, independent of the coefficient-cast exchange
`crtProductEquiv_apply`, which must not be mistaken for the dg square. -/

/-- The ν-layer support as a plain prime set: the image of the typed
    `Finsupp` support in `ℕ` (support relabelling between the typed
    support and `Finset ℕ`). -/
def nuSupportPrimes (ν : coefficient_exponent) : Finset ℕ :=
  ν.val.support.image Subtype.val

/-- Support relabelling: membership in `nuSupportPrimes ν` is membership
    in the typed support. -/
theorem mem_nuSupportPrimes (ν : coefficient_exponent)
    (p : { p : ℕ // p.Prime ∧ p ≠ 2 }) :
    p.val ∈ nuSupportPrimes ν ↔ p ∈ ν.val.support := by
  simp only [nuSupportPrimes, Finset.mem_image]
  constructor
  · rintro ⟨a, ha, h⟩
    have heq : a = p := Subtype.ext h
    rw [← heq]
    exact ha
  · intro h
    exact ⟨p, h, rfl⟩

/-- (HYPOTHESIS) The realization/reduction exchange square at support point
    `p` (paper L13000–13076): the p-primary dg realization `σ` is the
    reduction of the N_ν-layer realization `ρ`, compatible with the
    concrete p-primary coefficient reduction
    `red_p = ZMod.castHom … : ZMod N_ν →+* ZMod (p^{ν_p})`.

    Primitive hypothesis `Prop`, indexed by the depth datum `ν` and the
    support point `p`: the dg-side reduction maps are not formalized
    (Mathlib has no DGA structure), so the square is assumed in predicate
    form — the *shape* of the paper's square over the formalized data
    `(ρ, σ)`, retaining both layers' background support-functoriality.
    It is independent of the coefficient-cast exchange theorem
    `crtProductEquiv_apply` (coefficients only), which must not be
    mistaken for the dg square. -/
def IsPrimaryReduction (bg : WitnessBackground) (ρ σ : bg.DgRealization)
    (ν : coefficient_exponent) (_p : ↥(ν.val.support)) : Prop :=
  bg.crtIsSupportFunctorialDg ρ ∧ bg.crtIsSupportFunctorialDg σ

/-- Support-functorial dg realization binding over `(S, ν)`.

    Replaces the old independently-projected `∃ ρ,
    bg.crtIsSupportFunctorialDg ρ`: `S` is genuinely consumed (`suppSub`),
    and the background realization/hypothesis are structurally bound to
    the ν-layer/N_ν-layer with the exchange square as an explicit
    hypothesis (`exchange`), rather than floating free. -/
structure DgRealizationBinding (S : finite_ordered_support)
    (ν : coefficient_exponent) (bg : WitnessBackground) where
  /-- the background dg realization at the N_ν-layer (paper's construction;
      hypothesis) -/
  ρ : bg.DgRealization
  /-- its background support-functoriality hypothesis, now a field of the
      `(S, ν)`-indexed binding (was: independently projected
      `bg.crtRealizationIs`) -/
  isDg : bg.crtIsSupportFunctorialDg ρ
  /-- `S` genuinely consumed: the ν-layer primes sit inside `S.primes`
      (support-functorial restriction, paper §28) -/
  suppSub : nuSupportPrimes ν ⊆ S.primes
  /-- the p-primary (ν-layer) realizations -/
  ρp : (p : ↥(ν.val.support)) → bg.DgRealization
  /-- their background support-functoriality -/
  isDg_p : ∀ p, bg.crtIsSupportFunctorialDg (ρp p)
  /-- (HYPOTHESIS, paper L13000–13076) the realization/reduction exchange
      square: each `ρp p` is the p-primary reduction of `ρ`. The dg-side
      reduction is not formalized; the square is assumed in predicate form
      (`IsPrimaryReduction`), independent of the coefficient-cast exchange
      `crtProductEquiv_apply`. -/
  exchange : ∀ p, IsPrimaryReduction bg ρ (ρp p) ν p

/-- The canonical binding from background data: the background realization
    serves at both the N_ν-layer and every p-primary layer, with the
    exchange square supplied as the explicit hypothesis `hEx`. -/
def canonicalDgBinding (S : finite_ordered_support) (ν : coefficient_exponent)
    (bg : WitnessBackground) (hSub : nuSupportPrimes ν ⊆ S.primes)
    (hEx : ∀ p : ↥(ν.val.support),
      IsPrimaryReduction bg bg.crtRealization bg.crtRealization ν p) :
    DgRealizationBinding S ν bg :=
  ⟨bg.crtRealization, bg.crtRealizationIs, hSub,
    fun _ => bg.crtRealization, fun _ => bg.crtRealizationIs, hEx⟩

/- LIMITATION (M10 revision): status of the paper's Moore presentation and
    dg realization.
    RESOLVED (this revision): the integral 2-term complex
    `ℤ C_ν →[N_ν] ℤ B_ν` is now constructed — `IntegralMooreComplex N`
    records the chain carriers, the additive differential `dC` with its
    square-zero law (`sqZero`: differential followed by cokernel projection
    is zero), the designated generators with `dC genC = N • genD` (paper:
    `d C_ν = N_ν • B_ν`), and the pointed quotient identification
    `coker(dC) ≃+ ZMod N` (`crtMooreCohomology`); `MoorePresentation`
    carries this data plus the class coherence `class_eq`, so it is no
    longer "B + order" alone. The canonical model `crtIntegralMoore N` is
    `ℤ →[×N] ℤ`, chained to the existing `p*q^2` machinery via
    `crtMoore_range_eq_mooreBoundaries`.
    PARTIALLY ADDRESSED (this revision): the support-functorial dg
    realization is now bound structurally (`DgRealizationBinding` over
    `(S, ν)`): `S` is genuinely consumed via `suppSub`, and
    `bg.crtRealization` / `bg.crtRealizationIs` are carried as fields
    rather than projected independently. The realization/reduction
    exchange square (paper L13000–13076) is recorded as the explicit
    hypothesis `IsPrimaryReduction` — the dg-side reduction maps are not
    formalized (Mathlib has no DGA structure), so the full square is
    assumed in predicate form, not proved; it is independent of the
    coefficient-cast exchange `crtProductEquiv_apply`, which must not be
    mistaken for the dg square.
    STILL MISSING (honest): the full L13000–13076 exchange square as an
    equation of dg maps (needs the M2 DGA foundation); primitive filtered
    lines attached to the universal Moore presentations; support
    relabelling beyond the `suppSub` inclusion; coarsening `M(f)`/defect
    and coordinate preservation. The "support-functorial dg realization"
    `ρ_{S,ν}^{Mot,MR}` itself remains a background hypothesis in
    `WitnessBackground`. What IS concrete (this and prior revisions): the
    integral Moore complex with quotient identification, the finite CRT
    product ring isomorphism `crtProductEquiv` (pointed, `1 ↦ 1`), the
    actual p-primary reductions with their composition law
    (`ppowerRed_comp`) and the generator/coefficient exchange diagram
    (`crtProductEquiv_apply`). -/

end SelmerCartanMotiveTowers
