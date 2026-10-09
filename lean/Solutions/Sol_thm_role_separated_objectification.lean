import Definitions.Def_motivic_moore_reedy
import Definitions.Def_finite_ordered_support
import Definitions.Def_role_separation

namespace SelmerCartanMotiveTowers

/-- Solution for Theorem 19.9 (`thm_role_separated_objectification`), M7.

We construct:
- the target `M` with `support = S`, `coeffOrder = N`, carrier
  `Fin S.primes.card ⊕ Fin S.primes.card`, `corrAlgebra = Bool`;
- the canonical role separation (`canonicalRoleSeparation S`):
  `Role = Fin card ⊕ Fin card`, `d = Sum.inl`, `e = Sum.inr`,
  disjoint by `Sum.inl_ne_inr`, edges marked exactly for `i < j` and
  witnessed by explicit `ControlEdge`s;
- `embed = id` (genuinely injective).

The edge `(0, 1)` exists because `2 ≤ card`. The `RoleSeparation`
structure guarantees: (1) `d`/`e` images are disjoint (so `d ≠ e` as
families — the old degenerate model is excluded by type); (2) every marked
edge is witnessed by a nonzero `ControlEdge` (not a free predicate).

REVISION NOTE (P1-2 deepening, 2026-10-09): Replaces the free-predicate
version. `isSeparated = fun _ => True` is now impossible: `separated`
is the real disjointness `∀ i j, d i ≠ e j`. `coeffOrder` is the general
`N`, not hardcoded 3. -/
theorem sol_thm_role_separated_objectification
    (S : finite_ordered_support) (h2 : 2 ≤ S.primes.card)
    (N : ℕ) (hNodd : Odd N) (hNsf : Squarefree N) (hN3 : 3 ≤ N)
    : ∃ (M : motivic_moore_reedy) (RS : RoleSeparation S)
        (embed : RS.Role → M.carrier),
        M.support = S ∧ M.coeffOrder = N ∧
        (∃ i j, RS.hasEdge i j) ∧
        Function.Injective embed := by
  have h0 : 0 < S.primes.card := by omega
  have h1 : 1 < S.primes.card := by omega
  refine ⟨{ support := S, coeffOrder := N,
            coeffOrder_odd := hNodd, coeffOrder_squarefree := hNsf,
            carrier := Fin S.primes.card ⊕ Fin S.primes.card,
            corrAlgebra := Bool },
          canonicalRoleSeparation S,
          id,
          rfl, rfl,
          ⟨⟨0, h0⟩, ⟨1, h1⟩, Nat.zero_lt_one⟩,
          Function.injective_id⟩

end SelmerCartanMotiveTowers
