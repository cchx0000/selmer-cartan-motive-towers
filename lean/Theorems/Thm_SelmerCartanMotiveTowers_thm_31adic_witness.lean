import Definitions.Def_adic_witness
import Definitions.Def_witness_background
import Solutions.Sol_thm_31adic_witness

namespace SelmerCartanMotiveTowers

/-- The 31-adic arithmetic witness (Theorem 37.1, `thm:paper1-31adic-witness`),
REVISED per Strategy A (axiomatic skeleton).

Assuming the witness arithmetic background (`WitnessBackground` §3: the
explicit 31-adic inputs — `K₀ = ℚ(√-331)` with exact-`λ₃₁ = 2` via the
Knospe rank-one criterion [CITED] and Qi split-prime Massey criterion
[CITED], the Qi Kummer element, carry normalization via Hensel certificates;
`K* = ℚ(√-15391)` with class number 93, the `C₃₁` quotient, Artin
reciprocity [CITED: NSW], Poitou–Tate duality [CITED: NSW], the Kummer
identification and its nonvanishing; the LLSWW procyclic Bockstein–Massey
theorem 4.3.1 [CITED]; global non-extension / local extension), the
branches `K₀` and `K*` satisfy the witness contract of Definition
`def:paper1-witness-contract` — (i) exact-`λ₃₁ = 2` repeated cubic with
carry normalization, (ii) the pointed nonzero class `κ₅^root`, (iii) the
Kummer–Bockstein–Massey identification, (iv) the recursive map through
stage 30 with no global extension. The contract is encoded in the
`adic_witness` structure (W1–W4, numerical 31-data as hypotheses); its
inhabitation is the explicit arithmetic local–global witness for the
terminal source obstruction (non-vacuity).

REVISION NOTE (P0-1, 2026-10-09, external-verifier todo.md): `Nonempty
adic_witness` is now a SUBSTANTIVE statement. The witness structure no longer
stores bare `Prop` labels for (W4); it carries an explicit arithmetic target
(`branchZero`, `branchStar`), a terminal obstruction group with a
distinguished class and a localization map, trivialization DATA witnessing
local vanishing, and the real predicate `terminalClass ≠ 0`. A degenerate
"both Props False" model is impossible — inhabiting the witness requires
exhibiting real data satisfying real equations. The background's
`WitnessBackground.kappa_ne_zero` is PROVED (not assumed): from the
Poitou–Tate pairing + nondegeneracy (EXT), the Kummer identification
`kummerClass = kappa` (LEM), and the specific nonzero pairing value (NUM).
It is routed into (W4b) by explicit identification; it is not a restatement
of the goal. -/
theorem thm_31adic_witness (bg : WitnessBackground) : Nonempty adic_witness :=
  SelmerCartanMotiveTowers.sol_thm_31adic_witness bg

end SelmerCartanMotiveTowers
