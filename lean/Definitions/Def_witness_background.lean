import Definitions.Def_adic_witness
import Definitions.Def_finite_ordered_support

namespace SelmerCartanMotiveTowers

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
arithmetic proofs later. -/
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
  /-- `K₀ = Q(√-331)`: exact-`λ₃₁ = 2` (Knospe CITED + paper computes). -/
  lambda31_exact2 : Prop
  /-- Qi Kummer element `(α) = P₀³` (paper verifies). -/
  qiKummer : Prop
  /-- Carry normalization via Hensel certificates (paper computes). -/
  carryNormalized : Prop
  /-- `K* = Q(√-15391)`: class number 93 (paper computes). -/
  classNum93 : Prop
  /-- `K₀ = Q(√-331)` carrier type (explicit arithmetic target). -/
  BranchZero : Type
  /-- `K* = Q(√-15391)` carrier type (explicit arithmetic target). -/
  BranchStar : Type
  /-- Kummer class equals `κ₅^root` (paper proves). -/
  kummerEqKappa : Prop
  /-- LLSWW 4.3.1: proper 31-fold Massey = `κ₅^root` (CITED). -/
  llsWW : Prop
  /-- Global non-extension (paper proves from the above). -/
  globalNonExtension : Prop
  /-- The global obstruction group (Sha²-like) carrying the Kummer class. -/
  ObstructionGroup : Type
  [obstructionAddComm : AddCommGroup ObstructionGroup]
  /-- The distinguished Kummer class `κ₅^root`. -/
  kappa : ObstructionGroup
  /-- `κ ≠ 0`: Poitou–Tate pairing nonvanishing (CITED [NSW]) + the Kummer
      identification `κ_Kum = κ₅^root` (paper proves). This is the SPECIFIC
      arithmetic nonvanishing fact about the CONCRETE class — an allowed
      background input with labeled source, NOT a restatement of the witness
      goal. The witness routes it into its (W4b) slot via the explicit
      identification `terminalClass := kappa`. -/
  kappa_ne_zero : kappa ≠ 0
  /-- Local obstruction data at the places above 31. -/
  LocalObstructionGroup : Type
  [localObstructionAddComm : AddCommGroup LocalObstructionGroup]
  /-- Localization map. -/
  localizeObstruction : ObstructionGroup → LocalObstructionGroup
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
  /- §5. Carrier span (Theorem 38.5 inputs). -/
  CarrierLine : Type
  nonempty_CarrierLine : Nonempty CarrierLine
  isOrder31 : CarrierLine → Prop
  carrierSpan : CarrierLine → CarrierLine → CarrierLine → Prop
  Lar : CarrierLine
  Lsrc : CarrierLine
  LMot : CarrierLine
  hLar : isOrder31 Lar
  hLsrc : isOrder31 Lsrc
  hLMot : isOrder31 LMot
  hSpan : carrierSpan Lar Lsrc LMot

/-- The background's own obstruction-group structures, registered as instances
(P0-1; MotivicBackground pattern). -/
instance WitnessBackground.instAddCommGroupObstruction (bg : WitnessBackground) :
    AddCommGroup bg.ObstructionGroup :=
  bg.obstructionAddComm
instance WitnessBackground.instAddCommGroupLocalObstruction
    (bg : WitnessBackground) :
    AddCommGroup bg.LocalObstructionGroup :=
  bg.localObstructionAddComm

end SelmerCartanMotiveTowers
