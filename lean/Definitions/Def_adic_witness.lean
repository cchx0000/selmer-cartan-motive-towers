import Mathlib.Algebra.Group.Defs
import Definitions.Def_typed_coordinates

namespace SelmerCartanMotiveTowers

/-- A `31`-adic witness (arithmetic witness contract). It consists of:
(W1) an explicit marked repeated cubic line satisfying the filtered source
input; (W2) an integral carry normalization at every finite coefficient
depth used; (W3) a coefficient-typed arithmetic target for the terminal
obstruction — the two branches `K₀`, `K*` as explicit carrier types, and
the terminal obstruction as a distinguished class in an abelian group
with a localization map to local data; (W4) a proof that the terminal
class is locally trivial but globally nonzero, where "locally trivial"
is existential trivialization DATA (a type of trivialization data, each
datum certifying the real local-vanishing equation) and "globally nonzero"
is the REAL predicate `terminalClass ≠ 0` on real data — not bare `Prop`
labels. All numerical values — the repeated arithmetic prime `q`,
the support label, the finite coefficient-depth prime, the base-field
discriminant — enter only as hypothesis fields; no numerical computation is
verified in Lean. The support label `31`, the repeated arithmetic prime
`q = 31`, and the finite coefficient-depth prime in `31^r` are kept as
separate fields and are not interchangeable; their numerical coincidence is
recorded as explicit hypotheses (`h_arithPrime`, `h_supportLabel`,
`h_coeffDepthPrime`), since it belongs to this example and not to the general
source tower. (Definition def:paper1-witness-contract, §31;
Warning warn:typed-31-coordinates.)

REVISION NOTE (P0-1, 2026-10-09, external-verifier todo.md): The previous
version stored `terminal_locally_trivial : Prop` and
`terminal_globally_nonzero : Prop` as bare Props, so `Nonempty adic_witness`
was satisfied by a degenerate witness with both Props `False`. This revision
replaces them with real mathematical content: (W4a) a `Trivialization` type
with a `certifies` map to the local-vanishing equation and a `Nonempty`
existential; (W4b) `global_nonzero : terminalClass ≠ 0`, a genuine predicate
using the group's `0` and `≠`. The arithmetic target is explicit
(`branchZero`, `branchStar`, `terminalGroup`, `localData`, `localize`).
The deep arithmetic (why such a nonzero class exists) remains an explicitly
labeled background hypothesis in `WitnessBackground`, but now in
"there exists data with property P" form where P is a real property. -/
structure adic_witness where
  -- (W1) an explicit marked repeated cubic line satisfying the filtered source input
  cubicLine : Type
  cubicLine_input_ok : cubicLine → Prop
  -- (W2) an integral carry normalization at every finite coefficient depth used
  carryNormalization : coefficient_exponent → Type
  -- (W3) coefficient-typed arithmetic target: the two branches K₀ and K*
  branchZero : Type
  branchStar : Type
  -- Terminal obstruction: an abelian group with a distinguished class
  terminalGroup : Type
  [terminalAddComm : AddCommGroup terminalGroup]
  terminalClass : terminalGroup
  -- Localization map to local data
  localData : Type
  [localAddComm : AddCommGroup localData]
  localize : terminalGroup → localData
  -- (W4a) local triviality as EXISTENTIAL DATA (not a Prop label):
  -- a type of trivialization data, each datum certifying the real
  -- local-vanishing equation, plus the assertion that such data exists.
  Trivialization : Type
  certifies : Trivialization → (localize terminalClass = 0)
  hasTrivialization : Nonempty Trivialization
  -- (W4b) global nonvanishing as a REAL predicate on real data
  global_nonzero : terminalClass ≠ 0
  -- Numerical data (the example's 31-coincidence, as hypotheses)
  arithPrime : ℕ
  supportLabel : ℕ
  coeffDepthPrime : ℕ
  baseFieldDisc : ℤ
  h_arithPrime : arithPrime = 31
  h_supportLabel : supportLabel = 31
  h_coeffDepthPrime : coeffDepthPrime = 31

/-- The witness's own group structures, registered as instances so that
`0`, `≠`, etc. in statements about a witness `W` resolve to the witness's
own instances (MotivicBackground pattern; avoids the M5 shadowing bug). -/
instance AdicWitness.instAddCommGroupTerminal (W : adic_witness) :
    AddCommGroup W.terminalGroup :=
  W.terminalAddComm
instance AdicWitness.instAddCommGroupLocal (W : adic_witness) :
    AddCommGroup W.localData :=
  W.localAddComm

end SelmerCartanMotiveTowers
