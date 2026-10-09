import Mathlib.Data.Finset.Basic
import Mathlib.Data.Nat.Prime.Defs

namespace SelmerCartanMotiveTowers

/-- A finite ordered prime support `S`: a finite set of primes equipped with
the natural order. A new prime changes support, whereas a higher valuation of
an existing prime changes depth, never support. Supports are functorial under
ordered support deletion. (Introduction; §18.) -/
structure finite_ordered_support where
  primes : Finset ℕ
  prime_mem : ∀ p ∈ primes, p.Prime

end SelmerCartanMotiveTowers
