import Definitions.Def_source_package

namespace SelmerCartanMotiveTowers

/-- Finite Confluent source package (Theorem 11.6,
`P1C-thm:finite-confluent-interface`): for finite support `S`, fixed order
`m`, and finite odd-prime depth datum `ν`, the constructions of the paper
assemble into the finite package `I^{Conf}_{S,m,ν}` with exactly those
parameters. Support deletion, relabelling, and direction-linear maps act
through the package; the five coordinates (support, multiplicity,
coefficient depth, obstruction height, realization) remain distinct, as
enforced by the `source_package` structure. -/
theorem thm_finite_confluent_interface
    (S : finite_ordered_support) (m : confluence_multiplicity)
    (ν : coefficient_exponent) :
    ∃ P : source_package,
      P.support = S ∧ P.confluenceMult = m ∧ P.coeffExponent = ν := by sorry

end SelmerCartanMotiveTowers
