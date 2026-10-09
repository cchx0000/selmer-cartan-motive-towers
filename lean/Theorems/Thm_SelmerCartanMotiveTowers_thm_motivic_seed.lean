import Definitions.Def_motivic_background
import Solutions.Sol_thm_motivic_seed

namespace SelmerCartanMotiveTowers

/-- Primitive motivic Moore seed (Theorem 12.2, `P2L-thm:v48r4-motivic-seed`),
REVISED per Strategy A (axiomatic skeleton).

Assuming the motivic arithmetic background (`MotivicBackground`: the root
Moore pair from `P2M-prop:appendix-root-moore-complex`, whose proof cites
the equivariant motivic six-functor formalism [Hoyois, Khan–Ravi], the
equivariant Chow identification [Choudhury–Deshmukh–Hogadi], and Totaro's
`CH^*(Bμ_N) = Z[ξ]/(Nξ)` computation giving the EXACT order `N`), for odd
`N` the pure-weight cyclotomic root localization supplies motivic classes
`b_mot`, `c_mot` with `d(b_mot) = 0`, `d(c_mot) = N • b_mot`, and the class
`[b_mot]` of exact additive order `N` in cohomology; the antecedent `c_mot`
is a genuine
root-localization correspondence (not a freely adjoined Moore generator).

REVISION NOTE (2026-10-09): The first draft was FALSE — it universally
quantified over an arbitrary `addOrder` function and `rootSupplied`
predicate while the conclusion required `addOrder b = N` and
`rootSupplied (b, c)` (countermodel: both constantly `False`/zero). This
revision takes the motivic background as an explicit hypothesis, which
provides the root pair with its exact-order property.

REVISION NOTE 2 (2026-10-09): removed the redundant `[AddCommGroup bg.Cochain]`
instance binder. `MotivicBackground` already carries `AddCommGroup Cochain` as
an instance field; the extra binder shadowed it, so `•`/`0` in the conclusion
elaborated against an *arbitrary unrelated* instance — making the statement
actually FALSE (countermodel: transport the group structure along `x ↦ x-1`
so that `0 = 1`; then `bg.d b = 0` is unsatisfiable since `bg.d` is constantly
the structure's zero). With the binder removed, `•`/`0` use the background
package's own instance, as intended.

REVISION NOTE 3 (2026-10-09, verifier P0-2): the conclusion now also asserts
`addOrderOf (bg.classOf b) = bg.N` — the paper's `ord[b_mot] = N` at
cohomology level (Totaro's `CH^*(Bμ_N)` computation). The cochain-level
`N • b = 0` + exactness did NOT rule out `b` being a boundary: a boundary
has class `0`, and `addOrderOf 0 = 1`. The new field `hb_class_order`
excludes this model — a boundary would force `1 = N`, contradicting
`3 ≤ N`. `isGenuine` is now characterized by `isGenuine_iff` (nonzero
`N`-torsion class satisfying the Moore relation), not an arbitrary label.

REVISION NOTE 4 (2026-10-09, verifier P0-2 integral-model fix): the
cochain-level `N • b = 0` and `∀ k < N, k • b ≠ 0` conjuncts are REMOVED.
They forced `d c_mot = 0` via `hc_boundary`, collapsing the paper's
integral two-term Moore model whose differential is `×N` (paper L5422–5426).
`b_mot` is a cycle but NOT `N`-torsion as a cochain; `d(c_mot) = N • b_mot`
is the genuine nonzero differential value. The `N`-torsion lives at
cohomology level only: `N • [b] = [d c] = 0` with `addOrderOf [b] = N`. -/
theorem thm_motivic_seed (bg : MotivicBackground) :
    ∃ (b c : bg.Cochain),
      bg.d b = 0 ∧ bg.d c = bg.N • b ∧
      addOrderOf (bg.classOf b) = bg.N ∧
      bg.isGenuine c :=
  SelmerCartanMotiveTowers.sol_thm_motivic_seed bg

end SelmerCartanMotiveTowers
