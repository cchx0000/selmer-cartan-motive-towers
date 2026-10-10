import Definitions.Def_witness_background

namespace SelmerCartanMotiveTowers

/-- The 31-primary depth index in `coefficient_exponent`: the witness's
finite-depth family is read off the background's per-depth reduction system
at the 31-component of the coefficient exponent (the paper's "finite
coefficient-depth prime in 31^r"). -/
private def p31idx : { p : ℕ // p.Prime ∧ p ≠ 2 } := ⟨31, by decide, by norm_num⟩

/-- Solution for Theorem 37.1 (`thm_31adic_witness`), the main GOAL.
P0-1 REVISED (2026-10-09) + CONTINUED (2026-10-10, external-verifier todo.md).

Strategy A assembly, now with real mathematical content: the witness
contract `adic_witness` is inhabited from the explicit 31-adic background
inputs in `WitnessBackground` §3 —
(W1) the marked repeated cubic line: the (I3) `QAdicLine` with the Qi Kummer
datum's principality-equation FORM `alpha = 3 • P0` (`qiKummerData.principalEq`
— the equation shape in an abstract group, NOT the actual `(α) = P₀³`
principal-divisor identity in `K₀`, which stays paper-side) and the
exact-`λ₃₁ = 2` numerical equation (`lambda31_eq`) — no longer bare
`Prop` labels;
(W2) integral carry normalization at every finite coefficient depth: the
per-depth carrier TYPES and restriction MAPS of the background's
`CarryReductionSystem` are wired into the witness's
`carryNormalization`/`carryRestrict` family at the 31-component of the
coefficient exponent. The family is no longer constant and restriction is no
longer the identity; the identity/composition LAWS are discharged by the
background's recorded compatibility laws. NOTE (verifier P0-1): the
exact-order facts (`redClassOrder`), the pointed reductions themselves, and
the compatible pointed section (`restrict_pointed`) STAY BACKGROUND — the
witness output contract does NOT retain them;
(W3) the explicit arithmetic target (`branchZero`/`branchStar` for
`K₀`/`K*`, the obstruction group with the distinguished Kummer class
`κ₅^root`, and the localization map). The background localization is a
bundled additive group homomorphism, but the witness contract stores only
its underlying function — additivity is NOT in the output contract. The
paper's REPORTED `K₀` discriminant value is recorded by
`h_baseFieldDisc : baseFieldDisc = -331`, routed from the background's
`K0disc` (a numeric hypothesis, not field-structure proof);
(W4a) local triviality via the background's trivialization DATA
(`trivNonempty`, each datum certifying the real local-vanishing equation);
(W4b) global nonvanishing via the PROVED lemma `WitnessBackground.kappa_ne_zero`;
(W4c) exact order 31 via the PROVED lemma
`WitnessBackground.kappa_exact_order31` — derived from the INDEPENDENT
torsion input `kappaTorsion31 : 31 • κ = 0` (coefficient profile) plus
`κ ≠ 0`, not assumed (anti-circularity fix).
The three 31 roles are the example's numerical coincidence (recorded as
hypotheses); the base-field discriminant is `K₀ = Q(√-331)`.

HONEST SCOPE: Kummer theory, local fields, and Poitou–Tate duality stay
background hypotheses (Strategy A). What narrowed is type-level arbitrariness:
exact order 31 derived (not assumed), branch-discriminant NUMERIC EQUATIONS
(not field-structure proofs), the Kummer equation FORM `alpha = 3 • P0`
(not the actual principal-divisor identity), `ZMod 31`-valued bilinear
pairing, per-depth exact `31^r` reductions with compatibility laws (background;
the output contract keeps only carrier types + restriction maps), and a
homomorphic background localization (the output contract stores only its
underlying function). -/
theorem sol_thm_31adic_witness (bg : WitnessBackground) : Nonempty adic_witness :=
  ⟨{ cubicLine := bg.QAdicLine,
     cubicLine_input_ok := fun _ =>
       bg.qiKummerData.alpha = 3 • bg.qiKummerData.P0 ∧ bg.lambda31 = 2,
     carryNormalization := fun e => bg.carrySystem.Red (e.val p31idx),
     carryRestrict := fun e₁ e₂ h x => bg.carrySystem.restrict (h p31idx) x,
     carryRestrict_refl := fun e x => bg.carrySystem.restrict_refl _ x,
     carryRestrict_trans := fun e₁ e₂ _e₃ h₁₂ h₂₃ x =>
       bg.carrySystem.restrict_trans (h₁₂ p31idx) (h₂₃ p31idx) x,
     branchZero := bg.BranchZero,
     branchZeroAdd := bg.bgBranchZeroAdd,
     branchStar := bg.BranchStar,
     branchStarMul := bg.bgBranchStarMul,
     terminalGroup := bg.ObstructionGroup,
     terminalAddComm := bg.obstructionAddComm,
     terminalClass := bg.kappa,
     localData := bg.LocalObstructionGroup,
     localAddComm := bg.localObstructionAddComm,
     localize := ⇑bg.localizeObstruction,
     Trivialization := bg.TrivDatum,
     certifies := bg.trivVanishes,
     hasTrivialization := bg.trivNonempty,
     global_nonzero := bg.kappa_ne_zero,
     terminalClassOrder := bg.kappa_exact_order31,
     arithPrime := 31,
     supportLabel := 31,
     coeffDepthPrime := 31,
     baseFieldDisc := bg.K0disc,
     h_arithPrime := rfl,
     h_supportLabel := rfl,
     h_coeffDepthPrime := rfl,
     h_baseFieldDisc := bg.K0disc_eq }⟩

/-- Traceability audit for Theorem 37.1 (verifier P0-1 acceptance,
2026-10-10): six VERIFIED algebraic/numerical conjuncts extracted from the
background, each with its allowed-input label — the formalizable part of the
paper's four conclusions (paper L15765–15774).
  (i)   exact-`λ₃₁ = 2` [CITED/NUM: `lambda31_eq`] and per-depth exact order
        `31^r` of the carry reductions [NUM/paper: `carrySystem.redClassOrder`];
  (ii)  the pointed nonzero class `κ₅^root` [PROVED: `kappa_ne_zero` from EXT
        pairing + LEM Kummer identification + NUM nonzero pairing value] of
        exact order 31 [PROVED: `kappa_exact_order31` from NUM 31-torsion +
        `κ ≠ 0`];
  (iii) the Kummer identification `kummerClass = kappa` [LEM/paper:
        `kummerEqKappa`]. NOT stated here: the proper 31-fold Massey identity
        — there is no Massey object in the formalization; `llsWW` is an UNUSED
        bare-`Prop` background label recording the paper's cited claim,
        neither assumed as a usable hypothesis nor proved;
  (iv)  local trivialization at the 31-adic places via background DATA
        [paper: `trivVanishes`]. NOT stated here: the "recursive map through
        stage 30" (source-tower content, M1–M16) and the "no global extension"
        half — `globalNonExtension` is an UNUSED bare-`Prop` background label,
        neither assumed as a usable hypothesis nor proved.
Do NOT describe this theorem as extracting all four conclusions: proper
Massey/Bockstein identities, the stage-30 map, and global nonextension are
absent from the statement (verifier P0-1, 2026-10-10). -/
theorem sol_thm_31adic_witness_trace (bg : WitnessBackground) :
    bg.lambda31 = 2
      ∧ (∀ r, addOrderOf (bg.carrySystem.redClass r) = 31 ^ r)
      ∧ bg.kappa ≠ 0
      ∧ addOrderOf bg.kappa = 31
      ∧ bg.kummerClass = bg.kappa
      ∧ (bg.TrivDatum → bg.localizeObstruction bg.kappa = 0) := by
  exact ⟨bg.lambda31_eq, fun r => bg.carrySystem.redClassOrder r, bg.kappa_ne_zero,
    bg.kappa_exact_order31, bg.kummerEqKappa, bg.trivVanishes⟩

end SelmerCartanMotiveTowers
