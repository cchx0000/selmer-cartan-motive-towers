import Definitions.Def_motivic_moore_reedy
import Definitions.Def_finite_ordered_support

namespace SelmerCartanMotiveTowers

/-- Solution for Theorem 19.9 (`thm_role_separated_objectification`), M7.

The paper (`P2M-thm:role-separated-objectification`) builds role-separated
controller/birth objects over the motivic target. We construct:
- the target with carrier `Fin S.primes.card ⊕ Fin S.primes.card`
  (d-copy and e-copy of the prime indices);
- `Role` as the same sum type; `d = Sum.inl`, `e = Sum.inr`;
- `controlMarked` by case analysis: marked exactly for
  `(Sum.inl i, Sum.inr j)` with `i.val < j.val`;
- `embed = id` (genuinely injective).

The index is `S.primes.card` (tied to the support, not freely chosen).
The edge `(0, 1)` exists because `2 ≤ card`: `controlMarked` reduces to
`0 < 1`. The marking `↔` holds by definitional reduction of the match.

REVISION NOTE (P1-2, 2026-10-09): Replaces the empty-model proof
(`n = 0`, `Role = Empty`). The new statement forces `n = S.primes.card`
with `2 ≤ card` and requires an actual marked edge. `Role = Empty` is
impossible (`Fin card → Empty` is uninhabited for `card ≥ 2`);
`Role = Unit` is impossible (the marking `↔` would force
`controlMarked () ()` to be both `True` and `False`). The target is
constructed rather than universally quantified, since injectivity into
an arbitrary carrier is unprovable.
-/
theorem sol_thm_role_separated_objectification
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
        Function.Injective embed := by
  have h0 : 0 < S.primes.card := by omega
  have h1 : 1 < S.primes.card := by omega
  refine ⟨{ support := S, coeffOrder := 3,
            coeffOrder_odd := ⟨1, rfl⟩, coeffOrder_squarefree := Nat.prime_three.squarefree,
            carrier := Fin S.primes.card ⊕ Fin S.primes.card,
            corrAlgebra := Bool },
          Fin S.primes.card ⊕ Fin S.primes.card,
          Sum.inl, Sum.inr,
          fun _ => True,
          fun r1 r2 => match r1, r2 with
            | Sum.inl i, Sum.inr j => i.val < j.val
            | _, _ => False,
          id,
          rfl, rfl,
          fun i => trivial,
          fun j => trivial,
          fun i j => Iff.rfl,
          ⟨⟨0, h0⟩, ⟨1, h1⟩, Nat.zero_lt_one⟩,
          Function.injective_id⟩

end SelmerCartanMotiveTowers
