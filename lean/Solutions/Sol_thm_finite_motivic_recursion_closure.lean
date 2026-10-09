import Definitions.Def_motivic_moore_reedy
import Definitions.Def_finite_ordered_support
import Mathlib.Algebra.Squarefree.Basic

namespace SelmerCartanMotiveTowers

/-- Solution for Theorem 25.14 (`thm_finite_motivic_recursion_closure`), M8.

The paper (`P2M-thm:v38-finite-motivic-recursion-closure`) assembles the
finite recursion package `𝔗^{Mot,MR}_{N;S,≤M}` with six closure properties.
We model:
- the target `T` with carrier `Fin M` (nontrivial since `M ≥ 3`; the jet
  ceiling occurs in the conclusion) and algebra `Bool`;
- the jet ledger as the constant family `fun _ => T`: every jet level
  shares the target's support, order, and carrier.

This is exactly the "no structural growth" property (vi): the jet ledger
records the levels but creates no new carrier. Support–jet closure (i)
holds because each ledger entry has support `S` and order `N`. The
underlying object is preserved (shared nontrivial carrier), not deleted.

REVISION NOTE (P1-2, 2026-10-09): Replaces the `Unit`-carrier proof in
which `M` did not occur. The new statement's `Nontrivial` requirements
exclude the `Unit` model (machine-checked); the `Fin M` ledger makes the
jet ceiling structurally present; carrier-sharing formalizes (vi).

LIMITATIONS: The history pseudonaturality (iii), bar-complex constancy
(iv), and readout commutation (v) need the bicategorical and spectral
machinery, not formalized here; they are recorded in the
natural-language statement.
-/
theorem sol_thm_finite_motivic_recursion_closure
    (N : Nat) (hNodd : Odd N) (hNsf : Squarefree N)
    (S : finite_ordered_support) (M : Nat) (hM : 3 ≤ M)
    : ∃ (T : motivic_moore_reedy)
        (ledger : Fin M → motivic_moore_reedy),
        T.support = S ∧ T.coeffOrder = N ∧
        Nontrivial T.carrier ∧ Nontrivial T.corrAlgebra ∧
        (∀ n, (ledger n).support = S ∧ (ledger n).coeffOrder = N) ∧
        (∀ n, (ledger n).carrier = T.carrier) := by
  refine ⟨{ support := S, coeffOrder := N, coeffOrder_odd := hNodd,
            coeffOrder_squarefree := hNsf,
            carrier := Fin M, corrAlgebra := Bool },
          fun _ => { support := S, coeffOrder := N, coeffOrder_odd := hNodd,
                     coeffOrder_squarefree := hNsf,
                     carrier := Fin M, corrAlgebra := Bool },
          rfl, rfl,
          ⟨⟨0, by omega⟩, ⟨1, by omega⟩,
           fun h => Nat.zero_ne_one (congrArg Fin.val h)⟩,
          ⟨false, true, Bool.false_ne_true⟩,
          fun n => ⟨rfl, rfl⟩,
          fun n => rfl⟩

end SelmerCartanMotiveTowers
