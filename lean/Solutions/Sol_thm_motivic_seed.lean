import Definitions.Def_motivic_background

namespace SelmerCartanMotiveTowers

/-- Solution for Theorem 12.2 (`thm_motivic_seed`), M5.

The motivic background package `MotivicBackground` supplies the root Moore
pair `(b_mot, c_mot)` with all required properties; the acceptance items are
now DERIVED from the faithful complex/cohomology interface and the geometric
antecedent data, not assumed.

REVISION NOTE 4 (2026-10-09, verifier P0-2): the cochain-level `N • b = 0`
and exactness conjuncts are REMOVED from the conclusion. The old fields
`hb_order`/`hb_exact` forced `d c_mot = 0` (via `hc_boundary`), collapsing
the integral Moore model whose differential is `×N`. The `N`-torsion now
lives only at cohomology level (`addOrderOf [b] = N`).

REVISION NOTE 5 (2026-10-10, verifier P0-2): `isGenuine` no longer applies
`classOf` to the (non-closed) antecedent. The old `isGenuine_iff` required
`N • classOf x = 0`, which entailed the cochain-level `N² • b_mot = 0`
(via `classOf_ker` and `d² = 0`) — incompatible with the integral Moore
model. The new characterization only takes cohomology classes of the
closed `b_mot`, and ties genuineness to the `GeometricAntecedent` data
(invariant root coordinate localizing to `b_mot`). The proof term is
unchanged: `bg.hc_genuine` still discharges `bg.isGenuine c`.

REVISION NOTE 6 (2026-10-11, verifier todo: faithful complex/cohomology
interface + geometric antecedent in the type):
- `MotivicBackground` now carries the faithful integral two-term complex
  interface: `Cycles`/`Boundaries` (kernel/image of `d`) with
  `cyclesQuotEquiv : (Cycles ⧸ Boundaries) ≃+ Cohomology` and `quot_compat`,
  so `classOf` on a cycle is honestly the quotient map followed by the
  identification (`classOfCyc_eq_quot`).
- The acceptance items are DERIVED, not assumed: `d b_mot = 0`
  (`hb_closed`) from `localize_closed` at the invariant root coordinate;
  `d c_mot = N • b_mot` (`hc_boundary`) from the motivic residue–divisor
  identity `gysin_moore` (`∂[t] = N[D_N]`); the cohomology-level `N`-torsion
  `N • [b_mot] = 0` (`n_smul_classOfCyc_b`) from the Moore relation plus
  `classOf_ker`; `[b_mot] ≠ 0` (`classOfCyc_b_ne_zero`) from the exact order.
  The only remaining arithmetic hypothesis is the EXT-labeled exact-order
  field `hb_class_order` (Totaro's `CH^*(Bμ_N)` computation).
- `GeometricAntecedent` now writes the root-stack data into the type:
  `uCoord`, `rootOp` with the `t = u^N` relation `root_pow`, nontriviality
  `rootOp_nontrivial` (rules out the `RootCoord := Unit`,
  `localize := fun _ => b` degenerate model), the Gysin map `gysin` with
  `gysin_rootCoord : gysin rootCoord = c_mot` tying the geometry to `c`,
  and `gysin_moore`.
The proof term below assembles the derived lemmas: `bg.hb_closed` and
`bg.hc_boundary` now refer to the derived theorems, not structure fields. -/
theorem sol_thm_motivic_seed (bg : MotivicBackground) :
    ∃ (b c : bg.Cochain),
      bg.d b = 0 ∧ bg.d c = bg.N • b ∧
      addOrderOf (bg.classOf b) = bg.N ∧
      bg.isGenuine c :=
  ⟨bg.b_mot, bg.c_mot, bg.hb_closed, bg.hc_boundary,
    bg.hb_class_order, bg.hc_genuine⟩

end SelmerCartanMotiveTowers
