import Mathlib.Data.ZMod.Basic
import Definitions.Def_motivic_moore_reedy
import Definitions.Def_finite_ordered_support
import Definitions.Def_role_separation

namespace SelmerCartanMotiveTowers

/-- Solution for Theorem 19.9 (`thm_role_separated_objectification`), M7.

We construct:
- the target `M` with `support = S`, `coeffOrder = N`, carrier the canonical
  role type `(Fin S.primes.card → ZMod N) × ZMod N`, `corrAlgebra = Bool`;
- the canonical role separation (`canonicalRoleSeparation S N hN3`):
  `d i = (δ_i, 1)`, `e i = (δ_i, 2)` with `δ_i` the Dirac delta
  (`Function.update 0 i 1`): both families are injective, and the images are
  disjoint since `(1 : ZMod N) ≠ 2` for `N ≥ 3`;
  the Boolean correspondences `U i` and summand projections `proj i j` are
  the additive idempotent maps from the Definitions file;
  edges are marked exactly for `i < j`, each witnessed by a `HomElem`
  evaluating as `proj_{ij} ∘ U_i` (paper item (ii));
- `embed = id` (genuinely injective).

The edge `(0, 1)` exists because `2 ≤ card`. The `RoleSeparation`
structure guarantees: (1) `d`/`e` are injective with disjoint images — the
old degenerate constant-family model is excluded by type; (2) every marked
edge is witnessed by a `HomElem` whose evaluation IS `proj_{ij} ∘ U_i`, the
machine-checked form of paper item (ii) ("each control edge is the indicated
objectwise evaluation of the genuine Boolean correspondence").

The carrier is `Nontrivial` (witnessed by `(0, 0) ≠ (0, 1)`, using
`(1 : ZMod N) ≠ 0`) and the correspondence algebra `Bool` is `Nontrivial`,
matching the non-degeneracy properties of the M6 target (Theorem 19.6): this
`M` is a valid input shape for the channel-complete realization.

REVISION NOTE (M7, 2026-10-11): Complete model replacement, retrying the
staged 2026-10-10 rewrite (which failed to build: missing `ZMod` import).
The old `Fin card ⊕ Fin card` model with left-projection `Add` and
`hom = id` witnesses is gone; see the Definitions file for the new
`HomElem` / `U` / `proj` model and its honest limitations. -/
theorem sol_thm_role_separated_objectification
    (S : finite_ordered_support) (h2 : 2 ≤ S.primes.card)
    (N : ℕ) (hNodd : Odd N) (hNsf : Squarefree N) (hN3 : 3 ≤ N)
    : ∃ (M : motivic_moore_reedy) (RS : RoleSeparation S N)
        (embed : RS.Role → M.carrier),
        M.support = S ∧ M.coeffOrder = N ∧
        Nontrivial M.carrier ∧ Nontrivial M.corrAlgebra ∧
        (∀ i j, RS.d i ≠ RS.e j) ∧
        (∃ i j, RS.hasEdge i j) ∧
        Function.Injective embed := by
  have h0 : 0 < S.primes.card := by omega
  have h1 : 1 < S.primes.card := by omega
  have h10 : (1 : ZMod N) ≠ 0 := by
    intro hcon
    have hh : ((1 : ℕ) : ZMod N) = 0 := by simpa using hcon
    rw [ZMod.natCast_eq_zero_iff, Nat.dvd_one] at hh
    omega
  have h12 : (1 : ZMod N) ≠ 2 := by
    intro h
    have h' : 1 % N = 2 % N := by
      have h1 : ((1 : ℕ) : ZMod N) = ((2 : ℕ) : ZMod N) := by
        simpa using h
      rwa [ZMod.natCast_eq_natCast_iff] at h1
    have e1 : 1 % N = 1 := Nat.mod_eq_of_lt (by omega)
    have e2 : 2 % N = 2 := Nat.mod_eq_of_lt (by omega)
    omega
  refine ⟨{ support := S, coeffOrder := N,
            coeffOrder_odd := hNodd, coeffOrder_squarefree := hNsf,
            carrier := (Fin S.primes.card → ZMod N) × ZMod N,
            corrAlgebra := Bool },
          canonicalRoleSeparation S N hN3,
          id,
          rfl, rfl,
          ⟨(0, 0), (0, 1), fun h => h10 (congrArg Prod.snd h).symm⟩,
          ⟨true, false, fun h => Bool.noConfusion h⟩,
          fun i j hcon => h12 (congrArg Prod.snd hcon),
          ⟨⟨0, h0⟩, ⟨1, h1⟩, Nat.zero_lt_one⟩,
          Function.injective_id⟩

end SelmerCartanMotiveTowers
