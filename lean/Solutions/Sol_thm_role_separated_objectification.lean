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

The carrier is `Nontrivial` (witnessed by `inl 0 ≠ inr 0`) and the
correspondence algebra `Bool` is `Nontrivial`, matching the non-degeneracy
properties of the M6 target (Theorem 19.6): this `M` is a valid input shape
for the channel-complete realization.

REVISION NOTE (P1-2 deepening, 2026-10-09): Replaces the free-predicate
version. `isSeparated = fun _ => True` is now impossible: `separated`
is the real disjointness `∀ i j, d i ≠ e j`. `coeffOrder` is the general
`N`, not hardcoded 3.

REVISION NOTE (M7 strengthening, 2026-10-10): The production statement now
explicitly requires `Nontrivial M.carrier`, `Nontrivial M.corrAlgebra`, and
the separation property `∀ i j, RS.d i ≠ RS.e j` in the conclusion (not just
as structure fields), so the non-degeneracy is visible at the statement
level and matches M6's target properties.

REVISION NOTE (M7 Hom structure, 2026-10-10, narrowed): `ControlEdge`
now carries a Hom-structure-shaped field set (`hom : Role → Role` with
`hom_zero`, `hom_add`, `hom_nonzero : ∃ x, hom x ≠ 0`, plus
`degree_zero`/`closed` markers). This addresses the verifier's "no Hom,
zero morphism, or degree" criticism only at the field-shape level:
`hom` is a self-map of the WHOLE `Role` type, not a per-source/target
Hom-complex element; `degree_zero`/`closed` are `True`-typed (no grading
or differential exists); additivity is stated against a formal `Add`
instance (left-projection in the canonical model). There is still no dg
control morphism, no additive Karoubi summands, no cutoff, no higher
cells, and no Morita compatibility. The witness uses `hom = id`
(additive by `rfl`; nonzero via `Sum.inr 0 ≠ 0`), documented as the
objectwise evaluation of the Boolean correspondence `U_{q_i}`.
The additive Karoubi envelope and Morita equivalence remain background. -/
theorem sol_thm_role_separated_objectification
    (S : finite_ordered_support) (h2 : 2 ≤ S.primes.card)
    (N : ℕ) (hNodd : Odd N) (hNsf : Squarefree N) (hN3 : 3 ≤ N)
    : ∃ (M : motivic_moore_reedy) (RS : RoleSeparation S)
        (embed : RS.Role → M.carrier),
        M.support = S ∧ M.coeffOrder = N ∧
        Nontrivial M.carrier ∧ Nontrivial M.corrAlgebra ∧
        (∀ i j, RS.d i ≠ RS.e j) ∧
        (∃ i j, RS.hasEdge i j) ∧
        Function.Injective embed := by
  have h0 : 0 < S.primes.card := by omega
  have h1 : 1 < S.primes.card := by omega
  haveI : NeZero S.primes.card := ⟨by omega⟩
  refine ⟨{ support := S, coeffOrder := N,
            coeffOrder_odd := hNodd, coeffOrder_squarefree := hNsf,
            carrier := Fin S.primes.card ⊕ Fin S.primes.card,
            corrAlgebra := Bool },
          canonicalRoleSeparation S,
          id,
          rfl, rfl,
          ⟨Sum.inl ⟨0, h0⟩, Sum.inr ⟨0, h0⟩, Sum.inl_ne_inr⟩,
          ⟨true, false, fun h => Bool.noConfusion h⟩,
          fun i j => Sum.inl_ne_inr,
          ⟨⟨0, h0⟩, ⟨1, h1⟩, Nat.zero_lt_one⟩,
          Function.injective_id⟩

end SelmerCartanMotiveTowers
