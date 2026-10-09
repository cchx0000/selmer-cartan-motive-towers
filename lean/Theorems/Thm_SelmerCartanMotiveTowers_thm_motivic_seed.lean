import Definitions.Def_motivic_background

namespace SelmerCartanMotiveTowers

/-- Primitive motivic Moore seed (Theorem 12.2, `P2L-thm:v48r4-motivic-seed`),
REVISED per Strategy A (axiomatic skeleton).

Assuming the motivic arithmetic background (`MotivicBackground`: the root
Moore pair from `P2M-prop:appendix-root-moore-complex`, whose proof cites
the equivariant motivic six-functor formalism [Hoyois, Khan–Ravi], the
equivariant Chow identification [Choudhury–Deshmukh–Hogadi], and Totaro's
`CH^*(Bμ_N) = Z[ξ]/(Nξ)` computation giving the EXACT order `N`), for odd
`N` the pure-weight cyclotomic root localization supplies motivic classes
`b_mot`, `c_mot` with `d(b_mot) = 0`, `d(c_mot) = N • b_mot`, and `b_mot`
of exact additive order `N`; the antecedent `c_mot` is a genuine
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
package's own instance, as intended. -/
theorem thm_motivic_seed (bg : MotivicBackground) :
    ∃ (b c : bg.Cochain),
      bg.d b = 0 ∧ bg.d c = bg.N • b ∧
      bg.N • b = 0 ∧ (∀ k : Nat, 0 < k → k < bg.N → k • b ≠ 0) ∧
      bg.isGenuine c := by sorry

end SelmerCartanMotiveTowers
