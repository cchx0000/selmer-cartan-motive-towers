import Definitions.Def_source_package

namespace SelmerCartanMotiveTowers

/-- Solution for Theorem 11.6 (`P1C-thm:finite-confluent-interface`).

The paper's Theorem 11.6 packages the finite confluent constructions into
the source package `I^{Conf}_{S,m,ν}` for a finite support `S`, a fixed
order `m`, and a finite odd-prime depth datum `ν`.  The `source_package`
structure carries exactly those three parameters together with seven
opaque carriers (base datum, Γ^m module, coefficient ring, confluence
algebra, torsion-defect functor, resonance divisor, PD carrier), whose
internal constructions are supplied by later definitions; the five
coordinates (support, multiplicity, coefficient depth, obstruction height,
realization) remain distinct by construction of the structure.

The proof is the direct assembly: given `S`, `m`, `ν`, take the package
with those parameters and `Empty` as the seven opaque carriers. -/
theorem solution
    (S : finite_ordered_support) (m : confluence_multiplicity)
    (ν : coefficient_exponent) :
    ∃ P : source_package,
      P.support = S ∧ P.confluenceMult = m ∧ P.coeffExponent = ν := by
  exact ⟨{ support := S, confluenceMult := m, coeffExponent := ν, baseDatum := Empty, gammaModule := Empty, coeffRing := Empty, confluenceAlgebra := Empty, torsionDefect := Empty, resonanceDivisor := Empty, pdCarrier := Empty }, rfl, rfl, rfl⟩

end SelmerCartanMotiveTowers
