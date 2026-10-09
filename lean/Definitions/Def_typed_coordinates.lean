import Mathlib.Data.Finset.Basic
import Mathlib.Data.Finsupp.Basic
import Mathlib.Data.Nat.Prime.Defs
import Definitions.Def_finite_ordered_support

namespace SelmerCartanMotiveTowers

/-- Confluence multiplicity: the fixed order `m`. It is typed separately from
support, coefficient exponent, obstruction height, and realization; no relation
such as "confluence multiplicity `m` equals coefficient exponent `ν_p`" is
built into the theory. (Introduction.) -/
structure confluence_multiplicity where
  val : ℕ

/-- Coefficient exponent: a finite odd-prime depth datum
`ν : P_odd → Z_{≥0}` with finite support. Its coefficient modulus is
`N_ν = ∏_p p^{ν_p}`, its coefficient ring `R_ν = Z/N_ν`, and its total weight
`|ν| = ∑_p ν_p`. (Definition 10.1.) -/
structure coefficient_exponent where
  val : { p : ℕ // p.Prime ∧ p ≠ 2 } →₀ ℕ

/-- Obstruction height: the index `n` of the lifting presentation. Support
size, confluence multiplicity, and coefficient exponent are parameters of each
stage and are never reindexed as obstruction height. (§26.) -/
structure obstruction_height where
  val : ℕ

/-- The five separately-typed coordinates: support, confluence multiplicity,
coefficient exponent, obstruction height, and realization. Each is its own
type or field; they are never merged, identified, or reindexed into one
another. (Introduction.) -/
structure typed_coordinates (Realization : Type) where
  support : finite_ordered_support
  confluenceMult : confluence_multiplicity
  coeffExponent : coefficient_exponent
  obstructionHeight : obstruction_height
  realization : Realization

end SelmerCartanMotiveTowers
