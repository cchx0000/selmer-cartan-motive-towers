import Definitions.Def_typed_coordinates

namespace SelmerCartanMotiveTowers

/-- The finite confluent source package
`I^{Conf}_{S,m,ν} = (D_S, Γ^m(D_S), R_ν, Conf(m), D_m, Res, W^{PD}_{N_ν;S,m})`
for a finite support `S`, a fixed order `m`, and a finite odd-prime depth
datum `ν`. Support deletion, relabelling, and direction-linear maps act
through `Γ^m`; confluence coarsenings act through the scalar `M(f)`, the
torsion-defect functor `D_m`, and the resonance divisor `Res(f)`. The seven
components are opaque carriers here; their internal constructions are
supplied by later definitions. Support, multiplicity, coefficient depth,
obstruction height, and realization remain distinct coordinates.
(Theorem P1C-thm:finite-confluent-interface.) -/
structure source_package where
  support : finite_ordered_support
  confluenceMult : confluence_multiplicity
  coeffExponent : coefficient_exponent
  baseDatum : Type
  gammaModule : Type
  coeffRing : Type
  confluenceAlgebra : Type
  torsionDefect : Type
  resonanceDivisor : Type
  pdCarrier : Type

end SelmerCartanMotiveTowers
