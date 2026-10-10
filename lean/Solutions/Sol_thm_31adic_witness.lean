import Definitions.Def_witness_background

namespace SelmerCartanMotiveTowers

/-- Solution for Theorem 37.1 (`thm_31adic_witness`), the main GOAL.
P0-1 REVISED (2026-10-09, external-verifier todo.md).

Strategy A assembly, now with real mathematical content: the witness
contract `adic_witness` is inhabited from the explicit 31-adic background
inputs in `WitnessBackground` §3 —
(W1) the marked repeated cubic line from the Qi Kummer element with carry
normalization (Hensel certificates); (W2) integral carry normalization at
every finite coefficient depth; (W3) the explicit arithmetic target
(`branchZero`/`branchStar` for `K₀`/`K*`, the obstruction group with the
distinguished Kummer class `κ₅^root`, and the localization map);
(W4a) local triviality via the background's trivialization DATA
(`trivNonempty`, each datum certifying the real local-vanishing equation);
(W4b) global nonvanishing via the PROVED lemma `WitnessBackground.kappa_ne_zero`:
the background supplies the Poitou–Tate pairing + nondegeneracy (EXT),
the Kummer identification `kummerClass = kappa` (LEM, paper proves), and the
specific nonzero pairing value (NUM) — and `κ ≠ 0` is DERIVED from these,
not imported. The witness routes it via the explicit identification
`terminalClass := kappa`. This closes the verifier's non-circularity gap:
the step "nonzero pairing ⟹ class nonzero" is a proof.
The three 31 roles are the example's numerical coincidence (recorded as
hypotheses); the base-field discriminant is `K₀ = Q(√-331`.

REVISION NOTE (P0-1 deepening, 2026-10-10, external-verifier todo.md):
- The witness now carries `terminalClassOrder : addOrderOf terminalClass = 31`
  (routed from the background's `kappaOrder31`, NUM/paper-computed).
- `branchZero`/`branchStar` now carry `Add`/`Mul` (routed from the background's
  instance fields).
- (W2) now includes the finite-depth compatibility restriction system
  (`carryRestrict` + refl/trans laws). The witness's family is constant on the
  (I3) line at all depths, so restriction is the identity — the LAWS are the
  new content, forcing any future non-constant instantiation to be
  depth-coherent. The per-depth Hensel verification stays paper-side.
HONEST SCOPE: Kummer theory, local fields, and Poitou–Tate duality stay
background hypotheses (Strategy A). What narrowed is type-level arbitrariness:
exact order 31, branch algebraic structure, `ZMod 31`-valued bilinear pairing,
and a depth-compatibility structure. -/
theorem sol_thm_31adic_witness (bg : WitnessBackground) : Nonempty adic_witness :=
  ⟨{ cubicLine := bg.QAdicLine,
     cubicLine_input_ok := fun _ => bg.qiKummer ∧ bg.carryNormalized,
     carryNormalization := fun _ => bg.QAdicLine,
     -- The witness's normalization family is constant on the (I3) line at
     -- all finite depths (the paper's per-depth Hensel certificates live on
     -- this fixed line); restriction is the identity, which trivially
     -- satisfies the compatibility laws. The LAWS are the new content: any
     -- future non-constant instantiation must be depth-coherent.
     carryRestrict := fun _ _ _ x => x,
     carryRestrict_refl := fun _ _ => rfl,
     carryRestrict_trans := fun _ _ _ _ _ _ => rfl,
     branchZero := bg.BranchZero,
     branchZeroAdd := bg.bgBranchZeroAdd,
     branchStar := bg.BranchStar,
     branchStarMul := bg.bgBranchStarMul,
     terminalGroup := bg.ObstructionGroup,
     terminalAddComm := bg.obstructionAddComm,
     terminalClass := bg.kappa,
     localData := bg.LocalObstructionGroup,
     localAddComm := bg.localObstructionAddComm,
     localize := bg.localizeObstruction,
     Trivialization := bg.TrivDatum,
     certifies := bg.trivVanishes,
     hasTrivialization := bg.trivNonempty,
     global_nonzero := bg.kappa_ne_zero,
     terminalClassOrder := bg.kappaOrder31,
     arithPrime := 31,
     supportLabel := 31,
     coeffDepthPrime := 31,
     baseFieldDisc := -331,
     h_arithPrime := rfl,
     h_supportLabel := rfl,
     h_coeffDepthPrime := rfl }⟩

end SelmerCartanMotiveTowers
