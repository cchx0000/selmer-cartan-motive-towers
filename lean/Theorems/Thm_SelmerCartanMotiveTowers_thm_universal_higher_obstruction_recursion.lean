import Definitions.Def_dga_obstruction
import Solutions.Sol_thm_universal_higher_obstruction_recursion

namespace SelmerCartanMotiveTowers

/-- Universal higher-obstruction recursion (Theorem 9.4,
`P1C-thm:universal-higher-obstruction-recursion`), PROVED from the DGA
Bianchi identity (P1-3 revision, 2026-10-09; gauge/filtration layer,
2026-10-11).

For a parity-graded DGA (`SuperDGA`, see `Def_dga_obstruction.lean`):
(i) the curvature `F(X) = dX + X²` of an odd `X` satisfies the Bianchi
identity, hence `dF = F·X - X·F` (the cocycle clause: in the paper's
PD-filtered setting, the RHS has higher degree, so `dΩ = 0`);
(ii) the curvature expansion `F(X+Y) = F(X) + dY + XY + YX + Y²` holds
(the lifting criterion: in the paper, the last three terms have higher
PD degree);
(iii) for an even gauge unit with `dg = 0`, the curvature-conjugation
formula `F(g·X·g⁻¹) = g·F(X)·g⁻¹` holds (proved, not definitional);
(iv) DGA homomorphisms preserve curvature (naturality);
(v) gauge conjugation preserves each PD filtration level
(`PDFiltration`, filtered naturality);
(vi) the level projection commutes with gauge conjugation (the
obstruction component is gauge-invariant).

REVISION NOTE (2026-10-09, P1-3): The previous version used
`FormalBackground` §1's arbitrary predicates (`obsCocycle`, `liftIff`,
etc.) as a conditional assembly. This version replaces them with a real
DGA structure (`SuperDGA`) and proves (i), (ii), (iv) from the Bianchi
identity. The PD filtration is not formalized (see `Def_dga_obstruction.lean`
LIMITATIONS); the "higher terms vanish" is the degree-counting conclusion.

REVISION NOTE (2026-10-11): clause (iii) was a definitional `rfl`
(`gaugeAct u X = u.g * X * u.g_inv`); it is replaced by the proved
curvature-conjugation formula, and clauses (v)–(vi) add the minimal PD
filtration layer (levels, inclusions, even-compatibility, level
projections) with filtered naturality of gauge conjugation proved. The
associated graded, marked jets, and the `dΩ = 0` degree-counting
conclusion remain future work. -/
theorem thm_universal_higher_obstruction_recursion :
    -- (i) Cocycle: Bianchi rearranged
    (∀ (S : SuperDGA) (X : S.A), S.isOdd X →
      S.d (SuperDGA.curvature S X) =
        (SuperDGA.curvature S X) * X - X * (SuperDGA.curvature S X)) ∧
    -- (ii) Lifting: curvature expansion
    (∀ (S : SuperDGA) (X Y : S.A),
      SuperDGA.curvature S (X + Y) =
        SuperDGA.curvature S X + S.d Y + X * Y + Y * X + Y * Y) ∧
    -- (iii) Gauge: curvature-conjugation formula (proved)
    (∀ (S : SuperDGA) (u : S.GaugeUnit) (X : S.A),
      SuperDGA.curvature S (S.gaugeAct u X) =
        u.g * (SuperDGA.curvature S X) * u.g_inv) ∧
    -- (iv) Naturality: DGA homs preserve curvature
    (∀ {S T : SuperDGA} (F : SuperDGA.DGAHom S T) (X : S.A),
      F.toFun (SuperDGA.curvature S X) = SuperDGA.curvature T (F.toFun X)) ∧
    -- (v) Filtered gauge naturality: conjugation preserves levels
    (∀ (S : SuperDGA) (P : S.PDFiltration) (u : S.GaugeUnit) (n : ℕ) (X : S.A),
      X ∈ P.Filt n → S.gaugeAct u X ∈ P.Filt n) ∧
    -- (vi) Filtered gauge naturality: projection commutes with conjugation
    (∀ (S : SuperDGA) (P : S.PDFiltration) (u : S.GaugeUnit) (n : ℕ) (X : S.A),
      P.proj n (S.gaugeAct u X) = S.gaugeAct u (P.proj n X)) :=
  SelmerCartanMotiveTowers.sol_thm_universal_higher_obstruction_recursion

end SelmerCartanMotiveTowers
