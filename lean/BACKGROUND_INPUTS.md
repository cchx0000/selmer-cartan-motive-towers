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
| `isGenuine`, `isGenuine_iff` | DEF | Characterized (P0-2, revised 2026-10-10): Moore relation `d x = N • b_mot` + `addOrderOf [b_mot] = N` + geometric antecedent present. `classOf` is NEVER applied to the non-closed antecedent `x` (old `N • classOf x = 0` entailed `N² • b = 0`, incompatible with integral Moore) |
| `GeometricAntecedent`, `geometricAntecedent` | EXT | Invariant root coordinate data (paper L5422–5426, `∂[t] = N[D_N]`): `rootCoord`, `localize`, `localizesTo : localize rootCoord = b_mot`. Cited Hoyois / Khan–Ravi (equivariant six-functor). Added 2026-10-10 (verifier P0-2): `isGenuine` is tied to this data. Strengthened 2026-10-11 (verifier P0-2): `rootOp`/`uCoord` with `root_pow : rootOp^[N] uCoord = rootCoord` (`t = u^N`) and `rootOp_nontrivial` (kills the `RootCoord := Unit` degenerate model), Gysin map `gysin` with `gysin_rootCoord : gysin rootCoord = c` and residue–divisor identity `gysin_moore : d (gysin r) = N • localize r` (EXT) |
| `b_mot` | EXT | Root Moore cycle; cited Totaro `CH^*(Bμ_N) = Z[ξ]/(Nξ)` via `P2M-prop:appendix-root-moore-complex`. (P0-2 deep: cochain-level `hb_order`/`hb_exact` deleted — N-torsion lives only in cohomology) |
| `hb_closed` | LEM | DERIVED 2026-10-11 (was EXT field): `d b_mot = 0` proved from `localize_closed` at the invariant root coordinate, not assumed |
| `hb_class_order` | EXT | `addOrderOf [b_mot] = N` in cohomology; same Totaro citation, cohomology-level (P0-2; excludes the boundary model) |
| `c_mot`, `hc_genuine` | EXT | Root antecedent; cited Hoyois / Khan–Ravi / Choudhury–Deshmukh–Hogadi |
| `hc_boundary` | LEM | DERIVED 2026-10-11 (was EXT field): `d c_mot = N • b_mot` proved from `gysin_moore` at the root coordinate |
| `Cycles`, `Boundaries`, `cyclesQuotEquiv`, `quot_compat`, `classOfCyc` | DEF | Faithful integral 2-term interface added 2026-10-11 (verifier P0-2): `Cycles = ker d`, `Boundaries = range d`, `cyclesQuotEquiv : (↥Cycles ⧸ comap Boundaries) ≃+ Cohomology`, `classOfCyc` = `classOf` on cycles factoring through the quotient |

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

Consumed by: M10 (`thm_prime_power_comparison`) — `crtRealization`, `crtRealizationIs` only. (P1-4: M10 now uses concrete `Def_crt_product` definitions; `crtLine`/`crtLineHas` are no longer projected.)

### §3 — 31-adic witness data (M14/goal; P0-1 revised)

| Field | Label | Source |
|---|---|---|
| `K0disc`, `K0disc_eq` | NUM | Paper's REPORTED `K₀ = Q(√-331)` discriminant value `-331` as a numeric equation; does not endow the branch type with number-field structure (P0-1 continuation) |
| `lambda31`, `lambda31_eq` | EXT/NUM | `K₀` exact `λ₃₁ = 2` as a numerical datum with its equation (was bare `Prop`); Knospe criterion cited + Bernoulli valuation computed |
| `qiKummerData : KummerDatum` | NUM/LEM | Records the principality-equation FORM `alpha = 3 • P0` in an abstract additive group (was bare `Prop`); NOT the actual principal-divisor identity — no domain/divisor bridge, and existence/verification of the real Qi Kummer element stays paper-side |
| `carrySystem : CarryReductionSystem` | NUM/LEM | Per-depth pointed primitive reductions of exact order `31^r` with canonical restriction maps + identity/composition laws and a compatible pointed section (was bare `Prop`); per-depth Hensel verification paper-computed |
| `KstarDisc`, `KstarDisc_eq` | NUM | Paper's REPORTED `K* = Q(√-15391)` discriminant value `-15391` as a numeric equation; does not endow the branch type with number-field structure (P0-1 continuation) |
| `classNumStar`, `classNumStar_eq` | NUM | `K*` class number 93 as a numerical datum with its equation (was bare `Prop`); paper computes via reduced forms |
| `BranchZero`, `BranchStar` | DEF | Explicit arithmetic targets `K₀`, `K*` (P0-1); now with minimal algebraic structure: `Add` on `K₀`, `Mul` on `K*` (P0-1 deepening) |
| `kummerClass` | DEF | The Kummer class `κ_Kum` from the Qi Kummer element |
| `kummerEqKappa` | LEM | `kummerClass = kappa` as a real equation (paper proves) |
| `kappaTorsion31` | NUM | `31 • kappa = 0`: the Kummer class is 31-torsion (coefficient-profile input; paper computes). The exact order is DERIVED, not assumed (anti-circularity, P0-1 continuation) |
| `WitnessBackground.kappa_exact_order31` (theorem, not a field) | PROVED | `addOrderOf kappa = 31` DERIVED from `kappaTorsion31` + `kappa_ne_zero` via `addOrderOf_eq_prime`. **Anti-circularity**: the old `kappaOrder31` field assumed the conclusion (and implied `κ ≠ 0`, mooting the pairing derivation); now torsion and nonvanishing are independent inputs. |
| `llsWW` | LABEL | Bare-`Prop` background label recording the cited LLSWW Thm 4.3.1 claim (proper 31-fold Massey); UNUSED by any proof term — neither assumed as a usable hypothesis nor proved |
| `globalNonExtension` | LABEL | Bare-`Prop` background label recording the paper's global-nonextension claim (paper-side proof); UNUSED by any proof term — neither assumed as a usable hypothesis nor proved |
| `ObstructionGroup`, `AddCommGroup`, `kappa` | DEF | Global obstruction group (Sha²-like) + distinguished class |
| `poitouTatePairing` | EXT | Poitou–Tate pairing (cited [NSW]), now valued in the 31-primary part of `ℚ/ℤ` modeled as `ZMod 31` (P0-1 deepening); the pairing itself is background |
| `pairing_add_left`, `pairing_add_right` | EXT | Bilinearity laws of the pairing (cited [NSW]); make "nontrivial pairing" a statement about a nonzero value |
| `pairingDetectsNonzero` | EXT | Pairing nondegeneracy: pairing to a nonzero value ⟹ nonzero class (cited [NSW]) |
| `kummerPairingNonzero` | NUM/EXT | The specific nonzero pairing value for the Kummer class (in `ZMod 31`) |
| `WitnessBackground.kappa_ne_zero` (theorem, not a field) | PROVED | `κ ≠ 0` DERIVED from the above three inputs + `kummerEqKappa`. **Anti-circularity fix**: previously a bare field; now the derivation is a proof. |
| `LocalObstructionGroup`, `AddCommGroup`, `localizeObstruction` | DEF | Local data + localization map as a bundled additive group homomorphism (was an arbitrary function; P0-1 continuation) |
| `TrivDatum`, `trivNonempty`, `trivVanishes` | LEM | Local extension at 31-adic places; paper proves; each datum certifies the real equation |

Consumed by: M14/goal (`thm_31adic_witness`) — routes §3 data into `adic_witness` W1–W4.

### §4 — Gerbe provenance (M15)

| Field | Label | Source |
|---|---|---|
| `Gerbe`, `nonempty_Gerbe`, `isMu31Gerbe`, `gerbe`, `gerbeIs` | DEF | μ₃₁-gerbe setup |
| `provenanceFor` | DEF | Provenance relation (UNBOUND predicate; retained per P1-5 M15 — not deleted, not tied to `gerbeProvenanceData`) |
| `gerbeProvenance` | EXT | Dwyer defining-system theorem (cited) in LLSWW form + §3 data. Note: the `∀ W` quantification is strong; it records the cited theorem's uniformity, not a per-witness construction. |
| `gerbeProvenanceData` | EXT | Concrete operation-level provenance (P1-4 M15, strengthened P1-5 2026-10-11): `ClassifyingMap` (31 coordinates, `x^{(30)}, λ_*` profile, morphism bound to profile by `map_coords`; source `X_*` a bare type, NOT required to be a group), `PullbackIdentity` (genuine pullback operation `pullbackOp` with square equation `pullback_square`; chain `ρ̄^* ω = (x^{(30)},λ_*) = κ_5^{root} = c_1^{(31)}(Q_5)`), `UnipotentExtension` (P1-5: `AddCommGroup` on total `U` and quotient `Ū`; `proj : U → Ū` a surjective homomorphism; band action laws `smul_one`/`smul_add`/`smul_nat`/`proj_smul`; two-sided kernel identification `kernelMem_iff` derived from `projKernel` + `projKernelRev`; `kernelOrder` pins the cyclic subgroup at exact order 31), `ClassifyingPullbackSquare` (cartesian square, paper L15852–15864, with real commutativity equation; `G_{f_*}` and `B U` corners background). P0-0 fix (2026-10-10): the old centrality field forced `kernelGen = 0` and contradicted `kernelOrder`; corrected, with an author-reported `ZMod 31`-over-`ZMod 1` model (`unipotentExtensionModel`) as satisfiability evidence — coverage of that model under a reproducible build is pending per P0-3. NARROWED per P1-5: the old `base_eq` (bare type equality of extension base with classifying source) is replaced by `quotIdentification`, an explicitly ASSUMED identification map — not a verified identification. HONEST SCOPE: this is the GROUP-EXTENSION interface (`U → Ū`, paper L15805–15820) plus classifying/pullback data — NOT a verified algebraic `μ_{31}`-gerbe and NOT the gerbe projection `G_f → X_*` (L15852–15864); centrality is automatic in `AddCommGroup` and does not express non-abelian central extensions; the local model covers `UnipotentExtension` only — not the full `WitnessBackground` or its arithmetic realization, which remain background. `provenanceFor` retained as an UNBOUND predicate. Full stack construction CITED. |

Consumed by: M15 (`thm_gerbe_provenance`).

### §5 — Carrier span (M16; P1-4 rewritten)

| Field | Label | Source |
|---|---|---|
| `Lar`, `Lsrc`, `LMot` | DEF | Three concrete `pointed_cyclic_carrier`s (P1-4): the paper's arithmetic/source/motivic order-31 carriers, now as real pointed cyclic groups rather than opaque types + predicates. The span isomorphisms are **constructed** by M16's proof (`canonicalIso`), not assumed. |
| `hB : blockSubobjectInterface M bg.LMot` (theorem-level hypothesis, not a background field; 2026-10-10 revision replacing the old bare `hM : M.carrier ≃ bg.LMot.carrier`) | EXT | M16's assumed identification of a specified `I_*`-block subobject of the motivic target `M` with the concrete carrier `LMot`: block carrier + its `AddCommGroup` + block marking + injective embedding into `M.carrier` + pointed `≃+` to `L.carrier`; the paper's marked-ledger identification, recorded as input. The production witness is a pointed `ρ_block : bg.Lsrc.carrier ≃+ hB.blockCarrier` with `Function.Injective (hB.embed ∘ ρ_block)` — `M.carrier` itself is no longer treated as a 31-element line and no additivity/marking is claimed for it. **Distinguish**: the cyclic-carrier isomorphisms are constructed; the block identification `hB` is assumed. |
| (removed) | — | Old `CarrierLine` type + `isOrder31`/`carrierSpan`/`hLar`/`hLsrc`/`hLMot`/`hSpan` predicates deleted in P1-4. |

Consumed by: M16 (`thm_motivic_specialization`) — constructs `Lsrc ≃+ Lar` and `Lsrc ≃+ LMot` via `canonicalIso`; `witnessArithIso` gives `↥(zmultiples W.terminalClass) ≃+ Lar.carrier` (pointed, from `terminalClassOrder`); `ρ_block : Lsrc.carrier ≃+ hB.blockCarrier` via the block-subobject hypothesis `hB : blockSubobjectInterface M bg.LMot` (replacing the old bare-Equiv `hM`), with injective embedding `hB.embed ∘ ρ_block` into `M.carrier`.

**Note on M14's §3 usage**: M14 (`thm_31adic_witness`) routes `QAdicLine`, `qiKummerData` (principality-equation FORM `alpha = 3 • P0` — not the actual principal-divisor identity), `lambda31` (only the VALUE `bg.lambda31` enters the witness: the witness construction forms `cubicLine_input_ok` with the predicate `bg.lambda31 = 2` — the `= 2` comes from the witness contract, not from reusing the background's equation proof; `lambda31_eq : lambda31 = 2` is NOT routed into the witness — it is consumed separately, as the proof term for conjunct (i) of the trace theorem below), `carrySystem` (per-depth carrier types + restriction maps; the exact-order facts and the pointed section stay background), `K0disc` (reported discriminant VALUE, via the witness's `h_baseFieldDisc`), `ObstructionGroup`/`kappa`, `kummerClass`/`kummerEqKappa` (used by the proved `kappa_ne_zero` lemma), `kappaTorsion31` (used by the proved `kappa_exact_order31` lemma), `poitouTatePairing`/`pairingDetectsNonzero`/`kummerPairingNonzero`, `TrivDatum` (the background localization enters the witness as its underlying function only — additivity is not in the output contract) into the witness. The remaining §3 fields split into two honestly different categories (corrected 2026-10-10, verifier 3824afe5): (a) UNUSED-but-assumed numeric equation hypotheses — `KstarDisc`/`KstarDisc_eq : KstarDisc = -15391` and `classNumStar`/`classNumStar_eq : classNumStar = 93`: these are real equation FIELDS (usable proof terms in any proof, recorded numeric hypotheses), but no current proof term projects them and they are not routed into the witness; (b) bare-`Prop` background labels with no proof field — `llsWW : Prop`, `globalNonExtension : Prop`: they record paper-side claims, carry no proof content, are UNUSED by any proof term, and are neither assumed as usable hypotheses nor proved. The traceability theorem `sol_thm_31adic_witness_trace` proves six algebraic/numerical conjuncts (the formalizable part of Thm 37.1 (i)–(iv)); it does NOT state the proper Massey identity, the stage-30 recursive map, or global nonextension.

## FormalBackground (M2, M11, M12, M13)

Non-arithmetic. The four draft statements were FALSE as stated (arbitrary
predicates); this package supplies the paper's specific setups.

| Field | Label | Source |
|---|---|---|
| §1 `Jet`, `ObsClass`, `obstruction`, `vanishes`, `isCocycle`, `lifts`, `gaugeRelated`, `Op`, `actJet`, `actObs` | DEF | Obstruction-recursion setup |
| §1 `obsCocycle`, `liftIff`, `gaugeInv`, `natural` | LEM | Paper's dg-algebra proof (Bianchi + PD degrees); recorded as given — **conditional assembly**, not a substitute for the construction |
| §2 `FramedSector`, `nonempty_FramedSector`, `ZeroMotive`, `MooreSeed` | DEF | Source sector (paper-private; P1-3 keeps as background) |
| §2 `shadow` | LEM | The shadow functor itself (paper constructs; recorded as input) |
| §2 `shadowZero`, `shadowMoore` | LEM | CONCRETE (P1-3): `IsArtin` (`d = 0`) / `IsMoorePresentation` (`d > 0`) about `ClassicalMooreCone`; falsifiable, not arbitrary |
| `ClassicalMooreCone`, `reduce`, `reduce_refl`, `reduce_trans`, `line_order` | DEF/THM | PROVED (P1-3): `Q_d = Cone(d : T → T)[-1]` as explicit 2-term data; order-reduction `q_{d,d'}` with transitivity; `H¹ = ZMod d` (cokernel sits in degree 1) |
| §3 `DGCategory`, `nonempty_DGCategory`, `moduliStack`, `isDerivedStack`, `stackIsDerived` | DEF | Moduli of pseudo-perfect modules; the proposition has no proof in the paper (essentially definitional) |
| §4 `C`, `C'`, `eRec`, `eFull`, `eRecBijective`, `eFullBijective`, `eIntertwineProj`, `eIntertwineFull`, `eIntertwineOne` | EXT | Toën derived Morita theory (cited); representing data + consequences |

Consumed by: M11 (`shadow`, `shadowZero`, `shadowMoore`),
M12 (`stackIsDerived`), M13 (§4 fields).
(P1-3: M2 now uses independent `SuperDGA` definitions; FormalBackground §1 fields are no longer consumed.)

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
