# Background input ledger (external-verifier todo.md P1-1)

Every field of the four background packages is labeled by its epistemic
status, and each production theorem lists the exact fields it consumes.
Labels: **DEF** (definition / setup notion), **EXT** (external theorem,
cited to literature), **NUM** (numeric hypothesis / computed value),
**LEM** (lemma proved in the paper, recorded here as input for the
skeleton), **GOAL!** (restatement of the goal — forbidden; none present).

## ClassFieldBackground (M1)

| Field | Label | Source |
|---|---|---|
| `N`, `hNodd`, `hN1` | DEF | Setup: odd `N > 1` |
| `Place`, `nonempty_Place`, `aboveN` | DEF | §6 background notions |
| `KChar`, `nonempty_KChar`, `exactOrderN`, `ramSupp`, `cupVanishes`, `heisLift`, `masseyOrderN` | DEF | §6 background notions |
| `firstTwoRays` | LEM | `P1L-lem:first-two-rays`; paper proves via ray class fields + Kummer + global reciprocity |
| `heisenbergLift` | LEM | `P1L-prop:ray-heisenberg-lift`; paper proves (pure group cohomology; obstruction = cup product) |
| `thirdRay` | EXT | Chebotarev + ray class fields + Artin reciprocity; cited Neukirch ANT |
| `masseyExact` | EXT | Local Tate duality (local invariant a unit) + global reciprocity; cited Neukirch ANT |

Consumed by: M1 (`thm_ray_class_primitive`) — all four lemma/theorem fields.

## MotivicBackground (M5)

| Field | Label | Source |
|---|---|---|
| `N`, `hNodd`, `hN3` | DEF/NUM | Setup: odd `N ≥ 3` (`hN3` excludes the degenerate `N = 1` case) |
| `Cochain`, `AddCommGroup`, `nonempty_Cochain`, `d`, `hd2` | DEF | Cochain complex setup (`d² = 0`) |
| `Cohomology`, `AddCommGroup`, `classOf`, `classOf_ker` | DEF | Cohomology as quotient by boundaries (P0-2) |
| `isGenuine`, `isGenuine_iff` | DEF | Characterized (P0-2): Moore relation + nonzero N-torsion class; the paper's geometric "root coordinate" is formalized as its cohomological shadow (limitation noted in file) |
| `b_mot`, `hb_closed`, `hb_order`, `hb_exact` | EXT | Root Moore class of exact order `N`; cited Totaro `CH^*(Bμ_N) = Z[ξ]/(Nξ)` via `P2M-prop:appendix-root-moore-complex` |
| `hb_class_order` | EXT | `addOrderOf [b_mot] = N` in cohomology; same Totaro citation, cohomology-level (P0-2; excludes the boundary model) |
| `c_mot`, `hc_boundary`, `hc_genuine` | EXT | Root antecedent; cited Hoyois / Khan–Ravi / Choudhury–Deshmukh–Hogadi |

Consumed by: M5 (`thm_motivic_seed`) — all EXT fields.

## WitnessBackground (M10, M14/goal, M15, M16)

### §1 — Imported branch inputs (paper L5053, "imported hypotheses")

| Field | Label | Source |
|---|---|---|
| `q`, `hqPrime`, `hqOdd` | NUM | (I1): odd prime `q` |
| `QAdicLine`, `nonempty_QAdicLine`, `kappaTilde` | DEF | (I3): free rank-one `q`-adic line setup |
| `kappaBarNonzero`, `carryVec`, `carryVal` | NUM | (I3): nonzero residual point, distinguished carry vector of known valuation |
| `monomialNormalized` | LEM | (I2): paper assumes monomial normalization |
| `calibExactLambda3` | NUM | (I4): `K = Q(√-519)`, `p = 5`, exact `λ = 3` |

### §2 — Prime-power comparison (M10)

| Field | Label | Source |
|---|---|---|
| `PrimLine`, `nonempty_PrimLine`, `primPoint`, `primLineGood` | DEF | Pointed primitive filtered lines from (I3) |
| `CRTLine`, `nonempty_CRTLine`, `crtHasMoorePresentation`, `crtLine`, `crtLineHas` | LEM | Paper's CRT product construction (elementary CRT) |
| `DgRealization`, `nonempty_DgRealization`, `crtIsSupportFunctorialDg`, `crtRealization`, `crtRealizationIs` | LEM | Paper's support-functorial dg realization |

Consumed by: M10 (`thm_prime_power_comparison`) — `crtLine`, `crtLineHas`, `crtRealization`, `crtRealizationIs`.

### §3 — 31-adic witness data (M14/goal; P0-1 revised)

| Field | Label | Source |
|---|---|---|
| `lambda31_exact2` | EXT/NUM | `K₀ = Q(√-331)` exact `λ₃₁ = 2`; Knospe criterion cited + Bernoulli valuation computed |
| `qiKummer` | LEM | Qi Kummer element `(α) = P₀³`; paper verifies |
| `carryNormalized` | LEM | Hensel certificates; paper computes |
| `classNum93` | NUM | `K* = Q(√-15391)` class number 93; paper computes |
| `BranchZero`, `BranchStar` | DEF | Explicit arithmetic targets `K₀`, `K*` (P0-1) |
| `kummerEqKappa` | LEM | `κ_Kum = κ₅^root`; paper proves |
| `llsWW` | EXT | LLSWW Thm 4.3.1 (proper 31-fold Massey); cited |
| `globalNonExtension` | LEM | Paper proves from the above |
| `ObstructionGroup`, `AddCommGroup`, `kappa` | DEF | Global obstruction group (Sha²-like) + distinguished class |
| `kappa_ne_zero` | EXT | `κ ≠ 0` via Poitou–Tate pairing (cited [NSW]) + Kummer identification (paper proves). **Not GOAL!**: this is the specific arithmetic nonvanishing fact about the concrete class `κ₅^root`; the witness routes it via the explicit identification `terminalClass := kappa`. See P0-1 anti-circularity note in the file. |
| `LocalObstructionGroup`, `AddCommGroup`, `localizeObstruction` | DEF | Local data + localization map (P0-1) |
| `TrivDatum`, `trivNonempty`, `trivVanishes` | LEM | Local extension at 31-adic places; paper proves; each datum certifies the real equation |

Consumed by: M14/goal (`thm_31adic_witness`) — routes §3 data into `adic_witness` W1–W4.

### §4 — Gerbe provenance (M15)

| Field | Label | Source |
|---|---|---|
| `Gerbe`, `nonempty_Gerbe`, `isMu31Gerbe`, `gerbe`, `gerbeIs` | DEF | μ₃₁-gerbe setup |
| `provenanceFor` | DEF | Provenance relation |
| `gerbeProvenance` | EXT | Dwyer defining-system theorem (cited) in LLSWW form + §3 data. Note: the `∀ W` quantification is strong; it records the cited theorem's uniformity, not a per-witness construction. |

Consumed by: M15 (`thm_gerbe_provenance`).

### §5 — Carrier span (M16)

| Field | Label | Source |
|---|---|---|
| `CarrierLine`, `nonempty_CarrierLine`, `isOrder31`, `carrierSpan` | DEF | Order-31 carrier line setup |
| `Lar`, `Lsrc`, `LMot`, `hLar`, `hLsrc`, `hLMot`, `hSpan` | LEM | Paper's §38 construction (arithmetic carriers from §3, motivic from Moore seed) |

Consumed by: M16 (`thm_motivic_specialization`).

## FormalBackground (M2, M11, M12, M13)

Non-arithmetic. The four draft statements were FALSE as stated (arbitrary
predicates); this package supplies the paper's specific setups.

| Field | Label | Source |
|---|---|---|
| §1 `Jet`, `ObsClass`, `obstruction`, `vanishes`, `isCocycle`, `lifts`, `gaugeRelated`, `Op`, `actJet`, `actObs` | DEF | Obstruction-recursion setup |
| §1 `obsCocycle`, `liftIff`, `gaugeInv`, `natural` | LEM | Paper's dg-algebra proof (Bianchi + PD degrees); recorded as given — **conditional assembly**, not a substitute for the construction |
| §2 `FramedSector`, `Classical`, `ZeroMotive`, `MooreSeed`, `ArtinObj`, `MultNPresentation`, `shadow` | DEF | Shadow functor setup |
| §2 `shadowZero`, `shadowMoore` | LEM | Paper constructs the shadow functor; defining properties recorded |
| §3 `DGCategory`, `moduliStack`, `isDerivedStack`, `stackIsDerived` | DEF | Moduli of pseudo-perfect modules; the proposition has no proof in the paper (essentially definitional) |
| §4 `C`, `C'`, `eRec`, `eFull`, `eRecBijective`, `eFullBijective`, `eIntertwineProj`, `eIntertwineFull`, `eIntertwineOne` | EXT | Toën derived Morita theory (cited); representing data + consequences |

Consumed by: M2 (§1 fields), M11 (`shadow`, `shadowZero`, `shadowMoore`),
M12 (`stackIsDerived`), M13 (§4 fields).

## Cross-cutting notes

- **No GOAL! fields**: every EXT/LEM/NUM field has a labeled source
  distinct from the theorem it feeds. The closest calls are
  `kappa_ne_zero` (P0-1 documents the anti-circularity argument) and
  `FormalBackground` §1/§3/§4 conclusion-shaped fields (honestly marked
  "conditional assembly" above and in `todo.md` P1-1).
- Theorems M3, M4, M6, M7, M8, M9 consume no background package
  (M9 has its own explicit hypothesis binders).
- `adic_witness` (P0-1) now carries real data fields + the equation
  `terminalClass ≠ 0`; its `Nonempty` can no longer be witnessed by
  all-`False` Props (machine-checked in P0-1).
