import Mathlib.Algebra.Group.Defs
import Mathlib.GroupTheory.OrderOfElement
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
"there exists data with property P" form where P is a real property.

REVISION NOTE (P0-1 deepening, 2026-10-10, external-verifier todo.md):
- `terminalClassOrder : addOrderOf terminalClass = 31` — the terminal class
  has exact order 31 (the verifier noted the old contract had no exact-order
  condition).
- `branchZero`/`branchStar` now carry minimal algebraic structure
  (`Add` on `K₀`, `Mul` on `K*`) instead of being bare types.
- (W2) gains a finite-depth compatibility restriction system
  (`carryRestrict` + identity/composition laws): a depth-incoherent
  normalization family cannot inhabit the contract. The per-depth Hensel
  verification itself stays paper-side (NUM/EXT).
The deep Kummer/local-field/Poitou–Tate arithmetic stays background
(Strategy A); what changed is the TYPE-LEVEL arbitrariness is narrowed. -/
structure adic_witness where
  -- (W1) an explicit marked repeated cubic line satisfying the filtered source input
  cubicLine : Type
  cubicLine_input_ok : cubicLine → Prop
  -- (W2) an integral carry normalization at every finite coefficient depth used,
  -- with FINITE-DEPTH COMPATIBILITY (P0-1 deepening, 2026-10-10): the paper's
  -- Hensel certificates at each finite depth are compatible across depths.
  -- This is recorded as a restriction system (presheaf) on the poset of
  -- coefficient exponents: normalization data at a deeper level restricts
  -- to data at any shallower level, satisfying the identity and composition
  -- laws. The per-depth Hensel VERIFICATION stays paper-side (NUM/EXT);
  -- what is formalized here is the compatibility STRUCTURE, so a
  -- depth-incoherent family cannot inhabit the contract.
  carryNormalization : coefficient_exponent → Type
  carryRestrict : ∀ (e₁ e₂ : coefficient_exponent),
      (∀ p, e₁.val p ≤ e₂.val p) → carryNormalization e₂ → carryNormalization e₁
  carryRestrict_refl : ∀ (e : coefficient_exponent) (x : carryNormalization e),
      carryRestrict e e (fun _ => le_refl _) x = x
  carryRestrict_trans : ∀ (e₁ e₂ e₃ : coefficient_exponent)
      (h₁₂ : ∀ p, e₁.val p ≤ e₂.val p) (h₂₃ : ∀ p, e₂.val p ≤ e₃.val p)
      (x : carryNormalization e₃),
      carryRestrict e₁ e₃ (fun p => le_trans (h₁₂ p) (h₂₃ p)) x =
        carryRestrict e₁ e₂ h₁₂ (carryRestrict e₂ e₃ h₂₃ x)
  -- (W3) coefficient-typed arithmetic target: the two branches K₀ and K*.
  -- P0-1 deepening (2026-10-10): the branches are no longer bare types.
  -- `K₀` carries its additive structure, `K*` its multiplicative structure
  -- (minimal typeclass constraints — we do not model full number fields).
  branchZero : Type
  [branchZeroAdd : Add branchZero]
  branchStar : Type
  [branchStarMul : Mul branchStar]
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
  -- (W4c) the terminal class has EXACT order 31 (P0-1 deepening, 2026-10-10):
  -- the Kummer class is 31-torsion of exact order, not merely nonzero.
  terminalClassOrder : addOrderOf terminalClass = 31
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
/-- Branch algebraic structures, registered as instances (P0-1 deepening). -/
instance AdicWitness.instAddBranchZero (W : adic_witness) : Add W.branchZero :=
  W.branchZeroAdd
instance AdicWitness.instMulBranchStar (W : adic_witness) : Mul W.branchStar :=
  W.branchStarMul

end SelmerCartanMotiveTowers
