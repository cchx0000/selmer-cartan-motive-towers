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
datum's real principality equation `(α) = P₀³` (`qiKummerData.principalEq`)
and the exact-`λ₃₁ = 2` numerical equation (`lambda31_eq`) — no longer bare
`Prop` labels;
(W2) integral carry normalization at every finite coefficient depth: the
background's `CarryReductionSystem` — at each finite depth `r` a pointed
primitive reduction of EXACT order `31^r`, with canonical restriction maps
satisfying the identity/composition laws and a specified compatible pointed
section — wired into the witness's `carryNormalization`/`carryRestrict`
family at the 31-component of the coefficient exponent. The family is no
longer constant and restriction is no longer the identity; the LAWS are
discharged by the background's recorded compatibility laws;
(W3) the explicit arithmetic target (`branchZero`/`branchStar` for
`K₀`/`K*`, the obstruction group with the distinguished Kummer class
`κ₅^root`, and the localization map — now a bundled additive group
homomorphism, not an arbitrary function); the `K₀`-branch identity is
pinned by `h_baseFieldDisc : baseFieldDisc = -331`, routed from the
background's `K0disc`;
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
exact order 31 derived (not assumed), branch discriminants, the Kummer
principality equation, `ZMod 31`-valued bilinear pairing, per-depth exact
`31^r` reductions with compatibility laws, and a homomorphic localization. -/
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
2026-10-10): each of the paper's four conclusions (paper L15765–15774) is
extracted from the background below with its allowed-input label.
  (i)   `K₀` supplies an exact-`λ₃₁ = 2` repeated cubic [CITED/NUM:
        `lambda31_eq`] and a compatible family of pointed primitive
        reductions of exact order `31^r` at every finite `r` [NUM/paper:
        `carrySystem.redClassOrder`], with canonical carry normalization at
        every finite depth [NUM/paper: `carrySystem.restrict` laws];
  (ii)  `K*` supplies the pointed nonzero class `κ₅^root` [PROVED:
        `kappa_ne_zero` from EXT pairing + LEM Kummer identification + NUM
        nonzero pairing value] of exact order 31 [PROVED:
        `kappa_exact_order31` from NUM 31-torsion + `κ ≠ 0`];
  (iii) the displayed Kummer element represents the proper 31-fold Massey
        value [LEM/paper: `kummerEqKappa`; CITED: `llsWW`];
  (iv)  the recursive map extends at the 31-adic places [paper:
        `trivVanishes` data]; the "no global extension" half is the
        background field `globalNonExtension` (LEM: the paper proves it from
        the §32–37 chain) — recorded, not re-derived, here.
The "recursive map exists through stage 30" part of (iv) is source-tower
content (M1–M16), not witness-layer. -/
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
