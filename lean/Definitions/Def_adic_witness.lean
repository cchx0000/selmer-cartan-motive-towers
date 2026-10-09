import Definitions.Def_typed_coordinates

namespace SelmerCartanMotiveTowers

/-- A `31`-adic witness (arithmetic witness contract). It consists of:
(W1) an explicit marked repeated cubic line satisfying the filtered source
input; (W2) an integral carry normalization at every finite coefficient
depth used; (W3) a coefficient-typed arithmetic target for the terminal
obstruction; (W4) proofs that the terminal class is locally trivial but
globally nonzero. All numerical values — the repeated arithmetic prime `q`,
the support label, the finite coefficient-depth prime, the base-field
discriminant — enter only as hypothesis fields; no numerical computation is
verified in Lean. The support label `31`, the repeated arithmetic prime
`q = 31`, and the finite coefficient-depth prime in `31^r` are kept as
separate fields and are not interchangeable; their numerical coincidence is
recorded as explicit hypotheses (`h_arithPrime`, `h_supportLabel`,
`h_coeffDepthPrime`), since it belongs to this example and not to the general
source tower. (Definition def:paper1-witness-contract, §31;
Warning warn:typed-31-coordinates.) -/
structure adic_witness where
  cubicLine : Type
  cubicLine_input_ok : cubicLine → Prop
  carryNormalization : coefficient_exponent → Type
  terminalTarget : Type
  terminal_locally_trivial : Prop
  terminal_globally_nonzero : Prop
  arithPrime : ℕ
  supportLabel : ℕ
  coeffDepthPrime : ℕ
  baseFieldDisc : ℤ
  h_arithPrime : arithPrime = 31
  h_supportLabel : supportLabel = 31
  h_coeffDepthPrime : coeffDepthPrime = 31

end SelmerCartanMotiveTowers
