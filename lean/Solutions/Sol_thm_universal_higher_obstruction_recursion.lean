import Definitions.Def_dga_obstruction

namespace SelmerCartanMotiveTowers

/-- Solution for Theorem 9.4 (`P1C-thm:universal-higher-obstruction-recursion`),
P1-3 revision + 2026-10-11 gauge/filtration layer.

The clauses proved are:
- (i) `SuperDGA.bianchi_cocycle`: Bianchi rearranged as `dF = F·X - X·F`.
- (ii) `SuperDGA.curvature_expand`: `F(X+Y) = F(X) + dY + XY + YX + Y²`.
- (iii) `SuperDGA.curvature_gauge_conj`: for an even gauge unit with `dg = 0`,
  `F(g·X·g⁻¹) = g·F(X)·g⁻¹` — a genuine algebraic derivation (the
  differential part via `d_gauge_conj`/`d_mul_right_even`, the square part by
  telescoping with the two-sided inverse). This replaces the old
  definitional `rfl` clause (`gaugeAct u X = u.g * X * u.g_inv`), which
  restated the definition rather than proving a gauge property.
- (iv) `SuperDGA.naturality`: DGA homs preserve curvature.
- (v) `SuperDGA.gaugeAct_mem_filt`: gauge conjugation preserves each PD
  filtration level.
- (vi) `SuperDGA.gaugeAct_proj_comm`: the level projection commutes with
  gauge conjugation (the obstruction component is gauge-invariant).

The proof consumes no deep arithmetic (pure dg-algebra + filtration data).
The paper's full obstruction four items (dΩ = 0 via degree counting, the lift
iff with its H¹-torsor, marked jets, controller/parameter filtered
naturality) are still NOT established: the associated graded, marked jets,
and the `dΩ = 0` degree-counting conclusion remain future work (see
`Def_dga_obstruction.lean`). -/
theorem sol_thm_universal_higher_obstruction_recursion :
    (∀ (S : SuperDGA) (X : S.A), S.isOdd X →
      S.d (SuperDGA.curvature S X) =
        (SuperDGA.curvature S X) * X - X * (SuperDGA.curvature S X)) ∧
    (∀ (S : SuperDGA) (X Y : S.A),
      SuperDGA.curvature S (X + Y) =
        SuperDGA.curvature S X + S.d Y + X * Y + Y * X + Y * Y) ∧
    (∀ (S : SuperDGA) (u : S.GaugeUnit) (X : S.A),
      SuperDGA.curvature S (S.gaugeAct u X) =
        u.g * (SuperDGA.curvature S X) * u.g_inv) ∧
    (∀ {S T : SuperDGA} (F : SuperDGA.DGAHom S T) (X : S.A),
      F.toFun (SuperDGA.curvature S X) = SuperDGA.curvature T (F.toFun X)) ∧
    (∀ (S : SuperDGA) (P : S.PDFiltration) (u : S.GaugeUnit) (n : ℕ) (X : S.A),
      X ∈ P.Filt n → S.gaugeAct u X ∈ P.Filt n) ∧
    (∀ (S : SuperDGA) (P : S.PDFiltration) (u : S.GaugeUnit) (n : ℕ) (X : S.A),
      P.proj n (S.gaugeAct u X) = S.gaugeAct u (P.proj n X)) :=
  ⟨fun S X hX => SuperDGA.bianchi_cocycle S X hX,
   fun S X Y => SuperDGA.curvature_expand S X Y,
   fun S u X => SuperDGA.curvature_gauge_conj S u X,
   fun {S T} F X => SuperDGA.naturality F X,
   fun S P u n X hX => SuperDGA.gaugeAct_mem_filt S P u n X hX,
   fun S P u n X => SuperDGA.gaugeAct_proj_comm S P u n X⟩

end SelmerCartanMotiveTowers
