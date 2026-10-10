import Definitions.Def_adic_witness
import Definitions.Def_finite_ordered_support
import Definitions.Def_pointed_cyclic_carrier
import Definitions.Def_gerbe_provenance

namespace SelmerCartanMotiveTowers

/-- The Qi Kummer datum (paper §33): records the FORM of the paper's
principality identity `(α) = P₀³` as the equation `alpha = 3 • P0` in an
abstract additive group. This is an equation-FORM model, NOT the actual
principal-divisor identity: `DivGroup` is an arbitrary `AddCommGroup` —
there is no number-field element, no divisor-class-group map, no primality
of `P₀`, and no link to the `K₀` branch type. The paper's verification of
the actual Qi Kummer element stays paper-side (NUM/paper); what is
formalized here is the equation shape — real mathematical content, but
strictly weaker than the arithmetic statement (verifier P0-1, 2026-10-10). -/
structure KummerDatum where
  DivGroup : Type
  [divAddComm : AddCommGroup DivGroup]
  alpha : DivGroup
  P0 : DivGroup
  /-- `alpha = 3 • P0`: the equation FORM of `(α) = P₀³` (exact `P₀`-exponent
      3). The actual principal-divisor identity in `K₀` needs the
      domain/divisor bridge, which is not formalized (paper-side). -/
  principalEq : alpha = 3 • P0

/-- Per-depth pointed primitive carry reductions (Thm 37.1(i), paper §34).
`K₀` supplies, at every finite coefficient depth `r`, a pointed primitive
reduction of exact order `31^r`, with canonical restriction maps forming a
compatible system ("compatible family of pointed primitive reductions ...
with canonical carry normalization at every finite `r`"). The per-depth
Hensel verification is NUM/paper; the compatibility LAWS are recorded so
the formal family is a genuine presheaf with a specified global section —
the "specified compatible section" the verifier asked for (P0-1,
2026-10-10) — not a constant family. -/
structure CarryReductionSystem where
  Red : ℕ → Type
  [redAddComm : ∀ r, AddCommGroup (Red r)]
  /-- the pointed primitive reduction at depth `r` -/
  redClass : ∀ r, Red r
  /-- exact order `31^r` at depth `r` (Thm 37.1(i)) -/
  redClassOrder : ∀ r, addOrderOf (redClass r) = 31 ^ r
  /-- canonical restriction to a shallower depth -/
  restrict : ∀ {r₁ r₂ : ℕ}, r₁ ≤ r₂ → Red r₂ → Red r₁
  restrict_refl : ∀ (r : ℕ) (x : Red r), restrict (le_refl r) x = x
  restrict_trans : ∀ {r₁ r₂ r₃ : ℕ} (h₁₂ : r₁ ≤ r₂) (h₂₃ : r₂ ≤ r₃)
      (x : Red r₃),
      restrict (le_trans h₁₂ h₂₃) x = restrict h₁₂ (restrict h₂₃ x)
  /-- the pointed classes form a compatible section -/
  restrict_pointed : ∀ {r₁ r₂ : ℕ} (h : r₁ ≤ r₂),
      restrict h (redClass r₂) = redClass r₁

/-- The per-depth reduction groups' additive structures, registered as
instances (CarryReductionSystem pattern; cf. the background's obstruction
instances below). -/
instance CarryReductionSystem.instAddCommGroupRed (S : CarryReductionSystem)
    (r : ℕ) : AddCommGroup (S.Red r) :=
  S.redAddComm r

/-- The Kummer divisor group's additive structure, registered as an
instance (so the principality equation can be stated outside the
structure). -/
instance KummerDatum.instAddCommGroupDiv (D : KummerDatum) :
    AddCommGroup D.DivGroup :=
  D.divAddComm

/-- Witness arithmetic background package for Theorems 26.12, 37.1, 38.1,
38.5 (`P2M-thm:prime-power-all-support-comparison`,
`thm:paper1-31adic-witness`, `W31-thm:terminal-unipotent-gerbe-provenance`,
`W31-thm:common-source-motivic-span`).

This packages the explicit arithmetic inputs used by the witness-layer
proofs. All of the following are either ASSUMED by the paper (imported
hypotheses) or CITED to external literature / computed in the paper; none
are proved from first principles here.

§1. IMPORTED BRANCH INPUTS (`P1C-def:imported-hypotheses`, L5053).
The paper explicitly marks these as "imported hypotheses", assumed not proved:
- (I1) an odd repeated prime `q` with selected Qi-branch direction slots;
- (I2) monomial normalization of tripled coefficients;
- (I3) a free rank-one `q`-adic line with nonzero residual point and
  distinguished nonzero carry vector of known valuation;
- (I4) the calibration field `K = Q(√-519)` with `p = 5`, exact-`λ = 3`.

§2. PRIME-POWER COMPARISON INPUTS (for Theorem 26.12).
The proof consumes the EXISTENCE of the pointed primitive filtered lines
from (I3) (it does not reconstruct them). The CRT product line, its Moore
presentation, and the dg realization are the paper's construction
(elementary CRT + the channel realization); recorded here as given for the
skeleton.

§3. 31-ADIC WITNESS DATA (for Theorem 37.1, paper §32–37).
The proof is the cumulative §32–37 chain; its arithmetic inputs are:
- `K₀ = Q(√-331)`: 31 splits, class number 3, exact-`λ₃₁ = 2` via the
  Knospe rank-one criterion [KnospeSpecialValues2026] (CITED) + the Qi
  split-prime Massey criterion [QiMasseyLambda] (CITED) + the explicit
  Bernoulli valuation `v₃₁(B_{31,θ}) = 3` (paper computes);
  the Qi Kummer element `α` with `(α) = P₀³` (paper verifies);
  carry normalization via Hensel certificates (paper computes).
- `K* = Q(√-15391)`: class number 93 (paper computes via reduced forms);
  `P₊` of order 3; quotient `C₃₁`; `Q₅` generator (paper verifies);
  Artin reciprocity giving `z₅^root` (CITED: [NSW], standard);
  Poitou–Tate giving `Sha² ≅ F₃₁` (CITED: [NSW], standard);
  the Kummer identification `κ_Kum = κ₅^root` (paper proves) and its
  nonvanishing (via the Poitou–Tate pairing, CITED).
- LLSWW procyclic Bockstein–Massey Theorem 4.3.1 [LLSWW] (CITED),
  giving the proper 31-fold Massey identification.
- Global non-extension / local extension (paper proves from the above).

§4. GERBE PROVENANCE INPUTS (for Theorem 38.1).
The Dwyer defining-system theorem [DwyerMassey] (CITED), in the
Lam–Liu–Sharifi–Wake–Wang generalized form [LLSWW], identifying the
terminal curvature cocycle with the pullback of the universal
upper-unitriangular central extension class.

§5. CARRIER SPAN DATA (for Theorem 38.5).
The order-31 cyclic carrier lines (arithmetic from §3, motivic from the
Moore seed) and their pointed span.

STATUS: background hypothesis package. Each field is labeled with its
source. These are the concrete arithmetic inputs; per the user's decision,
they are introduced as hypotheses now and may be replaced by concrete
arithmetic proofs later.

P0-1 CONTINUATION (2026-10-10, external-verifier todo.md): the remaining
bare `Prop` labels of §3 (`lambda31_exact2`, `qiKummer`, `carryNormalized`,
`classNum93`) are replaced by structured data below — a `KummerDatum`
recording the principality-equation FORM `alpha = 3 • P0` (abstract additive
group; NOT the actual principal-divisor identity, whose domain/divisor
bridge stays paper-side), a `CarryReductionSystem` of per-depth pointed
primitive reductions of exact order `31^r` with compatibility laws,
numerical data with their equations (`lambda31 = 2`, `classNumStar = 93`),
and branch discriminants (`-331`, `-15391`) recording the paper's REPORTED
values (numeric hypotheses — they do not endow the branch types with
number-field structure). The exact-order field `kappaOrder31`
is replaced by the independent torsion input `kappaTorsion31 : 31 • κ = 0`
plus the DERIVED lemma `kappa_exact_order31` (anti-circularity). -/

structure WitnessBackground where
  /- §1. Imported branch inputs (assumed, not proved). -/
  q : Nat
  hqPrime : q.Prime
  hqOdd : q ≠ 2
  /-- (I3) Free rank-one `q`-adic line. -/
  QAdicLine : Type
  nonempty_QAdicLine : Nonempty QAdicLine
  kappaTilde : QAdicLine
  /-- (I3) Nonzero residual point `κ̄ ≠ 0`. -/
  kappaBarNonzero : Prop
  /-- (I3) Distinguished nonzero carry vector `γE`. -/
  carryVec : QAdicLine
  /-- (I3) Its valuation `s_car`. -/
  carryVal : Nat
  /-- (I2) Monomial normalization of tripled coefficients. -/
  monomialNormalized : Prop
  /-- (I4) Calibration field `K = Q(√-519)`, `p = 5`, exact-`λ = 3`. -/
  calibExactLambda3 : Prop
  /- §2. Prime-power comparison (Theorem 26.12 inputs). -/
  /-- Pointed primitive filtered lines from (I3). -/
  PrimLine : Type
  nonempty_PrimLine : Nonempty PrimLine
  primPoint : PrimLine
  primLineGood : Prop
  /-- CRT product line with its Moore presentation (paper's construction). -/
  CRTLine : Type
  nonempty_CRTLine : Nonempty CRTLine
  crtHasMoorePresentation : CRTLine → Prop
  crtLine : CRTLine
  crtLineHas : crtHasMoorePresentation crtLine
  /-- The dg realization (paper's construction). -/
  DgRealization : Type
  nonempty_DgRealization : Nonempty DgRealization
  crtIsSupportFunctorialDg : DgRealization → Prop
  crtRealization : DgRealization
  crtRealizationIs : crtIsSupportFunctorialDg crtRealization
  /- §3. 31-adic witness data (Theorem 37.1 inputs).
     P0-1 REVISION (2026-10-09, external-verifier todo.md): the bare Props
     `kappaRootNonzero` and `localExtension` are replaced by structured data
     — an explicit obstruction group with a distinguished class and a real
     nonvanishing equation, plus local data with a localization map and
     trivialization data. The deep arithmetic stays as explicitly labeled
     background hypotheses, now in "there exists data with property P" form
     where P is a real mathematical property. -/
  /-- `K₀ = Q(√-331)`: base-field discriminant (NUM, paper §32). This records
      the paper's REPORTED discriminant value as a numeric equation; it does
      not give the `K₀`-branch type any number-field structure. The witness's
      `baseFieldDisc` routes from here (verifier P0-1, 2026-10-10). -/
  K0disc : ℤ
  K0disc_eq : K0disc = -331
  /-- `K₀ = Q(√-331)`: exact-`λ₃₁ = 2` (CITED: Knospe rank-one criterion
      [KnospeSpecialValues2026] + Qi split-prime Massey criterion
      [QiMasseyLambda]; the value 2 is paper-verified). Recorded as a
      numerical datum with its equation, not a bare `Prop` label
      (verifier P0-1, 2026-10-10). -/
  lambda31 : ℕ
  lambda31_eq : lambda31 = 2
  /-- The Qi Kummer datum (paper §33): the principality-equation FORM
      `alpha = 3 • P0` in an abstract additive group. The paper's actual
      principal-divisor identity `(α) = P₀³` in `K₀` (existence + verification
      of the Qi Kummer element) stays paper-side (NUM/paper); what is
      formalized is the equation shape — real content, but not the arithmetic
      statement (verifier P0-1, 2026-10-10). -/
  qiKummerData : KummerDatum
  /-- Per-depth pointed primitive carry reductions (Thm 37.1(i), paper §34):
      at every finite coefficient depth `r`, a pointed primitive reduction
      of EXACT order `31^r`, with canonical restriction maps forming a
      compatible system. The per-depth Hensel VERIFICATION is NUM/paper;
      the compatibility LAWS are recorded so the formal family is a genuine
      presheaf with a specified global section, not a constant family
      (verifier P0-1, 2026-10-10). -/
  carrySystem : CarryReductionSystem
  /-- `K* = Q(√-15391)`: base-field discriminant (NUM, paper §32). This records
      the paper's REPORTED discriminant value as a numeric equation; it does
      not give the `K*`-branch type any number-field structure (verifier P0-1,
      2026-10-10). -/
  KstarDisc : ℤ
  KstarDisc_eq : KstarDisc = -15391
  /-- `K* = Q(√-15391)`: class number 93 (NUM: paper computes via reduced
      forms), as a numerical datum with its equation, not a bare `Prop`
      label (verifier P0-1, 2026-10-10). -/
  classNumStar : ℕ
  classNumStar_eq : classNumStar = 93
  /-- `K₀ = Q(√-331)` carrier type (explicit arithmetic target). -/
  BranchZero : Type
  /-- `K₀` additive structure (minimal; P0-1 deepening, 2026-10-10). -/
  [bgBranchZeroAdd : Add BranchZero]
  /-- `K* = Q(√-15391)` carrier type (explicit arithmetic target). -/
  BranchStar : Type
  /-- `K*` multiplicative structure (minimal; P0-1 deepening, 2026-10-10). -/
  [bgBranchStarMul : Mul BranchStar]
  /-- LLSWW 4.3.1 (proper 31-fold Massey identification) as a bare `Prop`
      BACKGROUND LABEL recording the paper's cited claim (CITED). It carries
      no proof content, is UNUSED by any proof term, and is neither assumed
      as a usable hypothesis nor proved — do not cite it as either
      (verifier P0-1, 2026-10-10). -/
  llsWW : Prop
  /-- Global non-extension as a bare `Prop` BACKGROUND LABEL recording the
      paper's claim (paper-side proof). It carries no proof content, is UNUSED
      by any proof term, and is neither assumed as a usable hypothesis nor
      proved — do not cite it as either (verifier P0-1, 2026-10-10). -/
  globalNonExtension : Prop
  /-- The global obstruction group (Sha²-like) carrying the Kummer class. -/
  ObstructionGroup : Type
  [obstructionAddComm : AddCommGroup ObstructionGroup]
  /-- The distinguished Kummer class `κ₅^root`. -/
  kappa : ObstructionGroup
  /-- The Kummer class `κ_Kum` from the Qi Kummer element `(α) = P₀³`. -/
  kummerClass : ObstructionGroup
  /-- Kummer identification `κ_Kum = κ₅^root` (paper proves). Now a real
      equation, not a bare `Prop` label. -/
  kummerEqKappa : kummerClass = kappa
  /-- The Kummer class is 31-torsion (NUM: the paper computes that
      `κ₅^root`, living in the `μ₃₁`-coefficient 31-primary part
      `Sha²_{S₃₁}(K*, μ₃₁)`, is killed by 31). This is the INDEPENDENT
      torsion input: it records where `κ` lives (coefficient profile), not
      its exact order. The exact order `addOrderOf κ = 31` is DERIVED below
      (`kappa_exact_order31`) from this plus `κ ≠ 0` (verifier P0-1
      anti-circularity, 2026-10-10). -/
  kappaTorsion31 : 31 • kappa = 0
  /-- Poitou–Tate pairing on the obstruction group (EXT, cited [NSW]),
      valued in the 31-primary part of `ℚ/ℤ`, modeled additively as
      `ZMod 31`. The pairing itself is background input (we do not prove
      class field theory); its bilinearity laws are recorded so that a
      "nontrivial pairing" is a statement about a NONZERO VALUE, not an
      arbitrary `Prop` relation.
      P0-1 deepening (2026-10-10): the verifier noted the old
      `G → G → Prop` was an arbitrary relation with no codomain. -/
  poitouTatePairing : ObstructionGroup → ObstructionGroup → ZMod 31
  /-- Bilinearity in the first argument (EXT, cited [NSW]). -/
  pairing_add_left : ∀ x₁ x₂ y,
      poitouTatePairing (x₁ + x₂) y =
        poitouTatePairing x₁ y + poitouTatePairing x₂ y
  /-- Bilinearity in the second argument (EXT, cited [NSW]). -/
  pairing_add_right : ∀ x y₁ y₂,
      poitouTatePairing x (y₁ + y₂) =
        poitouTatePairing x y₁ + poitouTatePairing x y₂
  /-- The pairing detects nonvanishing: a class pairing to a NONZERO value
      with something is nonzero. This is the instantiated nondegeneracy of
      the Poitou–Tate pairing (EXT, cited [NSW]) — a general fact about the
      pairing, not a fact about `kappa` specifically. -/
  pairingDetectsNonzero : ∀ x, (∃ y, poitouTatePairing x y ≠ 0) → x ≠ 0
  /-- The SPECIFIC arithmetic input: the Kummer class pairs to a nonzero
      value. (NUM/EXT: the paper's Poitou–Tate computation produces an
      explicit nonzero pairing value in `ZMod 31`.) This is the concrete
      numerical fact; everything downstream — in particular `κ ≠ 0` — is
      proved from it. -/
  kummerPairingNonzero : ∃ y, poitouTatePairing kummerClass y ≠ 0
  /-- Local obstruction data at the places above 31. -/
  LocalObstructionGroup : Type
  [localObstructionAddComm : AddCommGroup LocalObstructionGroup]
  /-- Localization map at the 31-adic places. Recorded as a bundled additive
      group homomorphism (EXT/paper: localization is a homomorphism), not an
      arbitrary function (verifier P0-1, 2026-10-10). -/
  localizeObstruction : ObstructionGroup →+ LocalObstructionGroup
  /-- Trivialization data for the local vanishing (local extension at the
      31-adic places, paper proves); each datum certifies the real equation. -/
  TrivDatum : Type
  trivNonempty : Nonempty TrivDatum
  trivVanishes : TrivDatum → (localizeObstruction kappa = 0)
  /- §4. Gerbe provenance (Theorem 38.1 inputs). -/
  Gerbe : Type
  nonempty_Gerbe : Nonempty Gerbe
  isMu31Gerbe : Gerbe → Prop
  gerbe : Gerbe
  gerbeIs : isMu31Gerbe gerbe
  provenanceFor : Gerbe → adic_witness → Prop
  /-- The gerbe has provenance for every witness (Dwyer CITED + §3 data). -/
  gerbeProvenance : ∀ W : adic_witness, provenanceFor gerbe W
  /-- The concrete operation-level provenance data (P1-4 M15): the
      classifying map with its `x^{(30)}, λ_*` coordinate profile, the
      pointed pullback identity `ρ̄^* ω = κ_5^{root} = c_1^{(31)}(Q_5)`,
      and the unipotent central extension with order-31 kernel.
      This is the structured form of `provenanceFor`; the full
      algebraic-stack construction remains background (CITED). -/
  gerbeProvenanceData : GerbeProvenance
  /- §5. Carrier span (Theorem 38.5 inputs).

  The three pointed cyclic order-31 carrier lines: the arithmetic line
  `L_*^{ar}` (from the `K*` branch's `κ₅^root` identification), the marked
  source line `L_*^{src}`, and the motivic Moore line `L_*^{Mot}` (the
  fixed Moore carrier in the `I_*`-block). Their specific
  arithmetic/motivic identity is background; the pointed span
  `L_*^{ar} ← L_*^{src} → L_*^{Mot}` is *proved* (Theorem 38.5) via the
  canonical generator-preserving isomorphisms
  (`pointed_cyclic_carrier.canonicalIso`), not assumed.

  CARRIER-LEVEL ONLY. The independent operation-level provenance
  (unipotent central extension, obstruction gerbe) is Theorem 38.1
  (`thm_gerbe_provenance`), not here. -/
  Lar : pointed_cyclic_carrier
  Lsrc : pointed_cyclic_carrier
  LMot : pointed_cyclic_carrier

/-- The background's own obstruction-group structures, registered as instances
(P0-1; MotivicBackground pattern). -/
instance WitnessBackground.instAddCommGroupObstruction (bg : WitnessBackground) :
    AddCommGroup bg.ObstructionGroup :=
  bg.obstructionAddComm
instance WitnessBackground.instAddCommGroupLocalObstruction
    (bg : WitnessBackground) :
    AddCommGroup bg.LocalObstructionGroup :=
  bg.localObstructionAddComm

/-- `κ ≠ 0`, PROVED from the pairing inputs + Kummer identification.

P0-1 ANTI-CIRCULARITY FIX (verifier todo.md): this was previously a bare
background field `kappa_ne_zero : kappa ≠ 0`, i.e. the conclusion imported
as input. Now the background supplies:
  (EXT) the Poitou–Tate pairing + its nondegeneracy (`pairingDetectsNonzero`),
  (LEM) the Kummer identification `kummerEqKappa : kummerClass = kappa`,
  (NUM) the specific nonzero pairing value `kummerPairingNonzero`;
and `κ ≠ 0` is DERIVED by rewriting the Kummer class to `kappa` and applying
nondegeneracy. The pairing itself stays background (no first-principles
class field theory), but the step "nonzero pairing value ⟹ class nonzero"
is a proof, not an assumption. -/
theorem WitnessBackground.kappa_ne_zero (bg : WitnessBackground) : bg.kappa ≠ 0 := by
  obtain ⟨y, hy⟩ := bg.kummerPairingNonzero
  rw [bg.kummerEqKappa] at hy
  exact bg.pairingDetectsNonzero _ ⟨y, hy⟩

/-- Exact order 31, DERIVED (not assumed).

P0-1 ANTI-CIRCULARITY (verifier todo.md, 2026-10-10): the previous field
`kappaOrder31 : addOrderOf kappa = 31` directly assumed the conclusion —
and since exact order 31 implies `κ ≠ 0`, it mooted the pairing-based
derivation of `kappa_ne_zero`. Now the background supplies two INDEPENDENT
inputs: (NUM) `kappaTorsion31 : 31 • kappa = 0` (the coefficient-profile
torsion — where `κ` lives) and (NUM) `kummerPairingNonzero` (the nonzero
pairing value — what `κ` does); both `κ ≠ 0` and `addOrderOf κ = 31` are
PROVED. The step uses `addOrderOf_eq_prime`: a nonzero `p`-torsion element
for prime `p` has exact order `p`. -/
theorem WitnessBackground.kappa_exact_order31 (bg : WitnessBackground) :
    addOrderOf bg.kappa = 31 := by
  have h31 : Fact (Nat.Prime 31) := ⟨by decide⟩
  exact addOrderOf_eq_prime bg.kappaTorsion31 bg.kappa_ne_zero

end SelmerCartanMotiveTowers
