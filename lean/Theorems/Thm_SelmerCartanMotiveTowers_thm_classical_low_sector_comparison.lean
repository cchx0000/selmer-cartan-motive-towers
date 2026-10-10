import Definitions.Def_formal_background
import Solutions.Sol_thm_classical_low_sector_comparison

namespace SelmerCartanMotiveTowers

/-- Classical low-sector comparison (Theorem 27.5,
`thm:classical-low-sector-comparison`), REVISED per Strategy A.

Assuming the formal background (`FormalBackground` §2: the paper's specific
classical shadow functor from the framed Cartan-generated root/Moore sector
to classical Moore cones), there exists a classical shadow functor sending
the rooted arithmetic zero-motive to the cone of zero (the Artin object,
`H¹ = ℤ`) and the primitive motivic Moore seed (with its genuine root-stack
antecedent) to a nontrivial Moore cone `Q_d` (the standard
multiplication-by-`d` presentation, `H¹ = ZMod d`).

P1-3 REVISION (2026-10-09): The target is now CONCRETE
(`ClassicalMooreCone`, the paper's `Q_d = Cone(d : T → T)[-1]` as explicit
2-term data).  `IsArtin`/`IsMoorePresentation` are concrete predicates
(`d = 0` / `d > 0`), not opaque.  The source sector and the shadow functor
itself remain background inputs (the paper's marked dg sector is not
formalizable in Mathlib); target-side cone computations (order-reduction
maps `q_{d,d'}`, transitivity, `H¹ = ZMod d`) are PROVED in
`Def_classical_shadow_cone`, not assumed.

REVISION NOTE (2026-10-09): The first draft was FALSE — it universally
quantified over arbitrary `FramedSector`/`Classical` types and unconstrained
predicates while the conclusion required `ArtinObj`/`MultNPresentation` to
be inhabited (countermodel: `ZeroMotive` true but `ArtinObj` constantly
`False`). This revision takes the paper's specific shadow setup as an
explicit hypothesis. The proof consumes no deep arithmetic.

REMAINING GAPS (2026-10-10, verifier M11 audit) — NOT formalized here:

* The source sector (`FramedSector`) and the shadow itself are background
  inputs: the paper's marked dg sector is not formalizable in Mathlib, and
  `bg.shadow` is an OBJECT FUNCTION, not a (homotopy-coherent) functor.
  Well-definedness on the framed sector, descent after forgetting the
  frame up to canonical isomorphism, the Moore pair / root-stack
  antecedent data, and the paper's (iii)–(iv) (successor components,
  exact-order reductions on bar cells, typed composites, tower
  compatibility) are not formalized; the two conclusion properties are
  assumed via `bg.shadowZero` / `bg.shadowMoore`.
* `ClassicalMooreCone.line = ZMod d`: the identification with `H¹` of the
  actual 2-term cone complex is not proved (the complex is not built in
  Lean); all target-side computations used here live in the numeric model.
  See the honesty note in `Def_classical_shadow_cone`.
* `IsMoorePresentation` records only `0 < d`, not the paper's coefficient
  `N` (paper (ii): seed ↦ `Q_{N,ℓ}` with `d = N` exactly); the exact
  binding `IsMoorePresentationAt` is defined but not assumed by the
  background. -/
theorem thm_classical_low_sector_comparison (bg : FormalBackground) :
    ∃ shadow : bg.FramedSector → ClassicalMooreCone,
      (∀ X, bg.ZeroMotive X → IsArtin (shadow X)) ∧
      (∀ X, bg.MooreSeed X → IsMoorePresentation (shadow X)) :=
  SelmerCartanMotiveTowers.sol_thm_classical_low_sector_comparison bg

end SelmerCartanMotiveTowers
