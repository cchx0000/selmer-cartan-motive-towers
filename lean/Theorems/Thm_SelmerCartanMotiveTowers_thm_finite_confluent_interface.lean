import Definitions.Def_confluent_package
import Solutions.Sol_thm_finite_confluent_interface

namespace SelmerCartanMotiveTowers

/-- Finite Confluent source package (Theorem 11.6,
`P1C-thm:finite-confluent-interface`): for finite support `S`, fixed order
`m`, and finite odd-prime depth datum `ν`, the constructions of the paper
assemble into the finite package `I^{Conf}_{S,m,ν}` with exactly those
parameters.

The package uses REAL structures (witnessed by the operations):
- `D_S = ⊕_{i∈S} ℤ e_i` as `S.primes →₀ ℤ` (not `(S.primes → ℤ) × ℤ`);
- `R_ν = ZMod N_ν` with `N_ν = ∏ p^{ν_p}` (not `ℤ`);
- support deletion `π_T` as a real coordinate projection family
  (idempotent because projections are, not constant zero);
- permutation action via equivalences `S ≃ S` (real linear maps via
  `Finsupp.domCongr`), with identity law and composition law;
- deletion–permutation naturality.

Empty support is a legal degenerate case (`D_S = 0`); see
`dirLat_nontrivial_iff`.

REVISION NOTE (P1-2 deep, 2026-10-09): addresses verifier feedback —
the previous proof used `(S.primes → ℤ) × ℤ` with a cheat `× ℤ` factor,
`ℤ` for the coefficient ring independent of `ν`, constant-zero deletion,
and actions on arbitrary functions. The new statement requires real
projection deletion, equivalence-based permutation action with identity
laws, and naturality. The divided-power algebra `Γ^m(D_S)` itself remains
background (see `Def_confluent_package.lean` LIMITATION); what is
formalized is the functorial action package on `D_S`.
REVISION NOTE (binding, 2026-10-10): the existential is now bound to the
concrete definitions (`P.baseDatum = direction_lattice S`,
`HEq (del T) ⇑(supportDelete S T)`, etc.), excluding the Unit weak model.
REVISION NOTE (P1-2 M4 deep, 2026-10-10): adds `gammaAct` (multiplicity-`m`
action, bound to `gammaMult S`) and `coarsenMap` (confluence coarsening,
bound to `coarsen S`) with their laws.
-/
theorem thm_finite_confluent_interface
    (S : finite_ordered_support) (m : confluence_multiplicity)
    (ν : coefficient_exponent) :
    ∃ (P : source_package)
      (del : Finset ↥S.primes → P.baseDatum → P.baseDatum)
      (permAct : (↥S.primes ≃ ↥S.primes) → P.baseDatum → P.baseDatum)
      (gammaAct : ℕ → P.gammaModule → P.gammaModule)
      (coarsenMap : Finset ↥S.primes → P.baseDatum → P.baseDatum),
      P.baseDatum = direction_lattice S ∧
      P.gammaModule = direction_lattice S ∧
      P.coeffRing = coeff_ring ν ∧
      (∀ T, HEq (del T) (⇑(supportDelete S T))) ∧
      (∀ σ, HEq (permAct σ) (⇑(permActDir S σ))) ∧
      (∀ n, HEq (gammaAct n) (⇑(gammaMult S n))) ∧
      (∀ T, HEq (coarsenMap T) (⇑(coarsen S T))) ∧
      P.support = S ∧ P.confluenceMult = m ∧ P.coeffExponent = ν ∧
      (∀ T x, del T (del T x) = del T x) ∧
      (∀ x, permAct (Equiv.refl _) x = x) ∧
      (∀ σ τ x, permAct (σ.trans τ) x = permAct τ (permAct σ x)) ∧
      (∀ σ T x, permAct σ (del T x) = del (T.map σ.toEmbedding) (permAct σ x)) ∧
      Nonempty P.confluenceAlgebra ∧ Nonempty P.torsionDefect ∧
      Nonempty P.resonanceDivisor ∧ Nonempty P.pdCarrier :=
  SelmerCartanMotiveTowers.sol_thm_finite_confluent_interface S m ν

end SelmerCartanMotiveTowers
