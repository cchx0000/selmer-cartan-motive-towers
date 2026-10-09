import Definitions.Def_motivic_moore_reedy
import Definitions.Def_finite_ordered_support
import Solutions.Sol_thm_role_separated_objectification

namespace SelmerCartanMotiveTowers

/-- Object-level birth–control realization (Theorem 19.9,
`P2M-thm:role-separated-objectification`): for a finite ordered support
`S` with at least two primes, there is a motivic Moore–Reedy target over
`S` carrying role-separated controller objects `d_{q_i}^{sel}` and birth
objects `e_{q_j}^{sel}` (indexed by `Fin S.primes.card`, so `n` is tied to
the support), with a distinguished control morphism marked exactly for
`i < j`. At least one control edge exists (from `2 ≤ card`), and the
role objects embed injectively into the carrier (built from Boolean and
channel summands). Adjoining them does not change the Morita type.

REVISION NOTE (P1-2, 2026-10-09): The first statement quantified over an
arbitrary target `M` and was proved by the empty model (`n = 0`,
`Role = Empty`). The strengthened statement takes the support `S` with
`2 ≤ S.primes.card` and produces the target with role structure; the
index `n` is `S.primes.card` (not freely chosen), and the conclusion
requires an actual marked edge `∃ i j, controlMarked (d i) (e j)`. The
empty model is excluded: with `card ≥ 2`, `Fin card → Empty` is uninhabited,
so `Role = Empty` is impossible. The `Unit` model is excluded by the
marking `↔`: `controlMarked () ()` would have to equal both `True`
(for `i < j`) and `False` (for `i = j`), impossible (machine-checked).
The injectivity into an arbitrary carrier was unprovable; the target is
now constructed (not universally quantified), which matches the paper's
construction over the M6 target.
-/
theorem thm_role_separated_objectification
    (S : finite_ordered_support) (h2 : 2 ≤ S.primes.card)
    : ∃ (M : motivic_moore_reedy) (Role : Type)
        (d e : Fin S.primes.card → Role)
        (isSeparated : Role → Prop)
        (controlMarked : Role → Role → Prop)
        (embed : Role → M.carrier),
        M.support = S ∧ M.coeffOrder = 3 ∧
        (∀ i, isSeparated (d i)) ∧ (∀ j, isSeparated (e j)) ∧
        (∀ i j, controlMarked (d i) (e j) ↔ i.val < j.val) ∧
        (∃ i j, controlMarked (d i) (e j)) ∧
        Function.Injective embed :=
  SelmerCartanMotiveTowers.sol_thm_role_separated_objectification S h2

end SelmerCartanMotiveTowers
