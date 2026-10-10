import Definitions.Def_confluent_package

namespace SelmerCartanMotiveTowers

/-- Solution for Theorem 11.6 (`thm_finite_confluent_interface`), M4.

We provide the REAL structures:
- `baseDatum := direction_lattice S = S.primes →₀ ℤ` (the marked direction
  lattice `D_S = ⊕_{i∈S} ℤ e_i`);
- `coeffRing := coeff_ring ν = ZMod N_ν` (the coefficient ring `R_ν`);
- `del T := supportDelete S T` (real coordinate projection);
- `permAct σ := permActDir S σ` (real linear action via `Finsupp.domCongr`).

The statement BINDS the existential to these concrete definitions:
`P.baseDatum = direction_lattice S`, `HEq (del T) ⇑(supportDelete S T)`, etc.
(HEq is used because `P` is abstract in the statement; the type equality
`P.baseDatum = direction_lattice S` is what excludes the Unit model.)
This excludes the Unit weak model: `Unit ≠ direction_lattice S` as types,
and constant functions cannot equal the real projections.

The four laws are the proved lemmas `supportDelete_idem`,
`permActDir_id`, `permActDir_comp`, `delete_perm_natural`.

For `gammaModule` we use `direction_lattice S` as the carrier of the
action package (the divided-power multiplication itself is background;
see `Def_confluent_package.lean` LIMITATION). The remaining four
carriers are `Unit` (their deep constructions are background).

REVISION NOTE (P1-2 deep, 2026-10-09): replaces the `(S.primes → ℤ) × ℤ`
cheat, `ℤ` coefficient ring, constant-zero deletion, and arbitrary-function
actions with the real `D_S`, real `R_ν`, real projections, and
equivalence-based actions.

REVISION NOTE (binding, 2026-10-10): the existential is now bound to the
concrete definitions via type equalities (`P.baseDatum = direction_lattice S`,
etc.) and function equalities (`del T = ⇑(supportDelete S T)`). The previous
statement allowed `P.baseDatum = Unit` with constant `del`/`permAct` to
satisfy all equations; the Unit weak model is now excluded.
-/
theorem sol_thm_finite_confluent_interface
    (S : finite_ordered_support) (m : confluence_multiplicity)
    (ν : coefficient_exponent) :
    ∃ (P : source_package)
      (del : Finset ↥S.primes → P.baseDatum → P.baseDatum)
      (permAct : (↥S.primes ≃ ↥S.primes) → P.baseDatum → P.baseDatum),
      P.baseDatum = direction_lattice S ∧
      P.gammaModule = direction_lattice S ∧
      P.coeffRing = coeff_ring ν ∧
      (∀ T, HEq (del T) (⇑(supportDelete S T))) ∧
      (∀ σ, HEq (permAct σ) (⇑(permActDir S σ))) ∧
      P.support = S ∧ P.confluenceMult = m ∧ P.coeffExponent = ν ∧
      (∀ T x, del T (del T x) = del T x) ∧
      (∀ x, permAct (Equiv.refl _) x = x) ∧
      (∀ σ τ x, permAct (σ.trans τ) x = permAct τ (permAct σ x)) ∧
      (∀ σ T x, permAct σ (del T x) = del (T.map σ.toEmbedding) (permAct σ x)) ∧
      Nonempty P.confluenceAlgebra ∧ Nonempty P.torsionDefect ∧
      Nonempty P.resonanceDivisor ∧ Nonempty P.pdCarrier := by
  refine ⟨{ support := S, confluenceMult := m, coeffExponent := ν,
            baseDatum := direction_lattice S,
            gammaModule := direction_lattice S,
            coeffRing := coeff_ring ν,
            confluenceAlgebra := Unit,
            torsionDefect := Unit,
            resonanceDivisor := Unit,
            pdCarrier := Unit },
          fun T => supportDelete S T,
          fun σ => permActDir S σ,
          rfl, rfl, rfl,
          fun T => HEq.rfl,
          fun σ => HEq.rfl,
          rfl, rfl, rfl,
          fun T x => supportDelete_idem S T x,
          fun x => by simp [permActDir_id],
          fun σ τ x => by
            beta_reduce
            exact congrArg (· x) (permActDir_comp S σ τ) |>.trans (AddEquiv.trans_apply _ _ _),
          fun σ T x => delete_perm_natural S σ T x,
          ⟨()⟩, ⟨()⟩, ⟨()⟩, ⟨()⟩⟩

end SelmerCartanMotiveTowers
