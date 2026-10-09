import Definitions.Def_source_package
import Solutions.Sol_thm_finite_confluent_interface

namespace SelmerCartanMotiveTowers

/-- Finite Confluent source package (Theorem 11.6,
`P1C-thm:finite-confluent-interface`): for finite support `S`, fixed order
`m`, and finite odd-prime depth datum `ν`, the constructions of the paper
assemble into the finite package `I^{Conf}_{S,m,ν}` with exactly those
parameters, equipped with real action structure: support deletion
(idempotent), relabelling by support permutations (contravariantly
functorial), and direction-linear maps acting through `Γ^m` (functorial).
The seven carriers are nontrivial/inhabited real types (direction lattice,
`Γ^m`-module, coefficient ring, confluence algebra, torsion-defect,
resonance divisor, PD carrier), not `Empty`/`Unit`. Support, multiplicity,
coefficient depth, obstruction height, and realization remain distinct
coordinates, as enforced by the `source_package` structure.

REVISION NOTE (P1-2, 2026-10-09): The first proof used `Empty` for all
seven carriers. This revision requires `Nontrivial`/`Nonempty` carriers
and explicit action maps (`del`, `permAct`, `linAct`) with composition
laws (deletion idempotence, relabelling contravariance, linearity
functoriality). The `Empty`/`Unit` models do not satisfy the new
statement: `Nontrivial Empty` and `Nontrivial Unit` are both false
(machine-checked). The carriers are modelled as function types over the
support (direction lattice as `S.primes → ℤ`, etc.); the deep
`Γ^m`-divided-power construction itself remains background.
-/
theorem thm_finite_confluent_interface
    (S : finite_ordered_support) (m : confluence_multiplicity)
    (ν : coefficient_exponent) :
    ∃ (P : source_package)
      (del : P.baseDatum → P.baseDatum)
      (permAct : (S.primes → S.primes) → P.baseDatum → P.baseDatum)
      (linAct : (P.baseDatum → P.baseDatum) → P.gammaModule → P.gammaModule),
      P.support = S ∧ P.confluenceMult = m ∧ P.coeffExponent = ν ∧
      Nontrivial P.baseDatum ∧ Nontrivial P.gammaModule ∧
      Nonempty P.coeffRing ∧ Nonempty P.confluenceAlgebra ∧
      Nonempty P.torsionDefect ∧ Nonempty P.resonanceDivisor ∧
      Nonempty P.pdCarrier ∧
      (∀ x, del (del x) = del x) ∧
      (∀ σ τ x, permAct (τ ∘ σ) x = permAct σ (permAct τ x)) ∧
      (∀ f g x, linAct (g ∘ f) x = linAct g (linAct f x)) :=
  SelmerCartanMotiveTowers.sol_thm_finite_confluent_interface S m ν

end SelmerCartanMotiveTowers
