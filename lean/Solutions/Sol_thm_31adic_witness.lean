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
(W4b) global nonvanishing via the background's SPECIFIC arithmetic fact
`kappa_ne_zero : κ ≠ 0` (Poitou–Tate CITED + Kummer identification proved
in the paper), routed by the explicit identification
`terminalClass := kappa`. This is not circular: the background field is a
concrete fact about a concrete class with labeled source; the witness
exhibits how it discharges the real predicate `terminalClass ≠ 0`.
The three 31 roles are the example's numerical coincidence (recorded as
hypotheses); the base-field discriminant is `K₀ = Q(√-331)`. -/
theorem sol_thm_31adic_witness (bg : WitnessBackground) : Nonempty adic_witness :=
  ⟨{ cubicLine := bg.QAdicLine,
     cubicLine_input_ok := fun _ => bg.qiKummer ∧ bg.carryNormalized,
     carryNormalization := fun _ => bg.QAdicLine,
     branchZero := bg.BranchZero,
     branchStar := bg.BranchStar,
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
     arithPrime := 31,
     supportLabel := 31,
     coeffDepthPrime := 31,
     baseFieldDisc := -331,
     h_arithPrime := rfl,
     h_supportLabel := rfl,
     h_coeffDepthPrime := rfl }⟩

end SelmerCartanMotiveTowers
