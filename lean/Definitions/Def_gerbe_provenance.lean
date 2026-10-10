import Mathlib.Algebra.Group.Defs
import Mathlib.Data.ZMod.Basic
import Definitions.Def_pointed_cyclic_carrier

namespace SelmerCartanMotiveTowers

/-- The classifying morphism `ρ̄_{f_*} : X_* → BŪ_{32}^{cyc}` (paper
`W31-thm:terminal-unipotent-gerbe-provenance`, L15832–15840).

The source `X_*` is the terminal proper-31-fold base; the target is the
classifying stack `BŪ_{32}^{cyc}` of the 32-dimensional cyclic unipotent
group. The map is recorded by its 31 adjacent coordinates: the first
thirty are the base coordinate `x`, the last is `λ_*`.

The full algebraic-stack structure of `BŪ_{32}^{cyc}` is background
(Mathlib has no algebraic stacks); what is formalized here is the
coordinate data the paper's proof actually uses: the 31-tuple shape and
the `x^{(30)}, λ_*` profile. -/
structure ClassifyingMap where
  /-- The source space `X_*`. -/
  source : Type
  /-- The target classifying stack `BŪ_{32}^{cyc}`. -/
  target : Type
  /-- The classifying morphism itself. -/
  map : source → target
  /-- The base coordinate `x` (repeated 30 times). -/
  x : source
  /-- The terminal coordinate `λ_*`. -/
  lambda_star : source
  /-- The 31 adjacent coordinates of the map. -/
  coords : Fin 31 → source
  /-- First thirty coordinates are `x` (paper: "whose first thirty
      adjacent coordinates are `x`"). -/
  coord_eq : ∀ i : Fin 31, (i.val < 30) → coords i = x
  /-- Last coordinate is `λ_*` (paper: "whose last adjacent coordinate
      is `λ_*`"). -/
  last_coord : coords 30 = lambda_star

/-- The pointed pullback identity (paper L15841–15848,
`W31-eq:terminal-unipotent-pullback`):
`ρ̄_{f_*}^* ω_{31}^{univ} = (x^{(30)}, λ_*)_{ρ_{f_*}} = κ_5^{root} = c_1^{(31)}(Q_5)`.

The universal obstruction class `ω_{31}^{univ}` pulls back along the
classifying map to the Massey value `(x^{(30)}, λ_*)`, which the LLSWW
specialization identifies with the root Kummer class `κ_5^{root}`, which
in turn equals the 31-primary Chern class `c_1^{(31)}(Q_5)`.

Formalized at the level of `ZMod 31` values: the pullback class, the
Kummer root class, and the Chern class are all elements of order 31,
and the paper's identity is their equality. The geometric pullback
operation `ρ̄^*` itself is background. -/
structure PullbackIdentity where
  /-- The pulled-back universal obstruction `ρ̄^* ω_{31}^{univ} : ZMod 31`. -/
  pullbackClass : ZMod 31
  /-- The root Kummer class `κ_5^{root} : ZMod 31`. -/
  kappa5root : ZMod 31
  /-- The 31-primary Chern class `c_1^{(31)}(Q_5) : ZMod 31`. -/
  c1_31_Q5 : ZMod 31
  /-- `ρ̄^* ω_{31}^{univ} = (x^{(30)}, λ_*) = κ_5^{root}`: the pullback
      equals the Kummer root class (LLSWW specialization). -/
  pullback_eq : pullbackClass = kappa5root
  /-- `κ_5^{root} = c_1^{(31)}(Q_5)`: the Kummer class is the Chern class. -/
  kappa_eq_chern : kappa5root = c1_31_Q5
  /-- The common class is nonzero (it is the obstruction). -/
  class_nonzero : pullbackClass ≠ 0

/-- The `μ_{31}`-gerbe as a unipotent central extension.

Records the kernel-generator data of a unipotent extension: an order-31
band generator `kernelGen` that is central. Narrowed per external-verifier
P0-0 (2026-10-10): this is NOT a verified genuine central extension —
the base `X_*` has no group structure, `proj` is not stated as a
homomorphism or surjection, and `projKernel` states only the one-sided
inclusion (kernel ⊆ `ZMod 31`-multiples of `kernelGen`), so the kernel
is not proved to equal the cyclic subgroup it generates. The `ZMod 31`
scalar action carries no stated action/module laws, and centrality
`∀ t, t + kernelGen = kernelGen + t` is automatic in any `AddCommGroup`.

REVISION NOTE (P0-0, 2026-10-10): the previous `kernelCentral` field was
`∀ t, ∃ n : ZMod 31, t + kernelGen = t`, whose unused `n` made the
statement force `kernelGen = 0` (take `t = 0`), contradicting
`kernelOrder`. It is replaced by the real centrality relation
`∀ t, t + kernelGen = kernelGen + t`; the projection/kernel relations
are now explicit (`projGenTrivial`, `projKernel`) with the scalar `n`
genuinely used. `unipotentExtensionModel` below gives an author-reported
satisfiability witness, so the OLD "empty type" verdict is withdrawn;
independent build coverage is pending per P0-3. -/
structure UnipotentExtension where
  /-- The base `X_*`. -/
  base : Type
  /-- The total space `G_{f_*}`. -/
  total : Type
  [totalAddComm : AddCommGroup total]
  /-- The `ZMod 31`-scalar action on the total space. Narrowed per P0-0:
      this is a bare `SMul` instance with NO stated action or module laws
      (identity, compatibility, additivity); it does not make the total
      space a verified `μ_{31}`-module. -/
  [totalScalar : SMul (ZMod 31) total]
  /-- The projection `G_{f_*} → X_*`. -/
  proj : total → base
  /-- The kernel generator (the `μ_{31}` band generator). -/
  kernelGen : total
  /-- The kernel has exact order 31 (necessary for a `μ_{31}`-gerbe;
      the stack structure itself is background). -/
  kernelOrder : addOrderOf kernelGen = 31
  /-- The kernel generator projects to the base identity: it lies in the
      kernel of `proj`. -/
  projGenTrivial : proj kernelGen = proj 0
  /-- The kernel of the projection is contained in the `ZMod 31`-multiples
      of the kernel generator (one-sided only: the reverse inclusion —
      every scalar multiple projects to the base identity — is not
      stated, so the kernel is not proved to equal that cyclic subgroup). -/
  projKernel : ∀ t : total, proj t = proj 0 → ∃ n : ZMod 31, t = n • kernelGen
  /-- Centrality: the kernel generator commutes with every total element. -/
  kernelCentral : ∀ t : total, t + kernelGen = kernelGen + t

/-- A concrete model: the cyclic group `ZMod 31` over the point, with
band generator `1`.

Satisfiability evidence for P0-0 (author-reported; independent build
coverage pending per P0-3): the corrected fields are jointly inhabited,
so the old "empty type" verdict on the `UnipotentExtension` premise is
withdrawn. This covers the extension layer only — it does not supply the
full `WitnessBackground`, its arithmetic realization, or a genuine
non-abelian central extension. -/
def unipotentExtensionModel : UnipotentExtension where
  base := Unit
  total := ZMod 31
  proj := fun _ => ()
  kernelGen := 1
  kernelOrder := ZMod.addOrderOf_one 31
  projGenTrivial := rfl
  projKernel := fun t _ => ⟨t, by rw [show t • (1 : ZMod 31) = t * 1 from rfl, mul_one]⟩
  kernelCentral := fun t => add_comm t 1

/-- The total space's group structure as an instance. -/
instance UnipotentExtension.instAddCommGroup (E : UnipotentExtension) :
    AddCommGroup E.total := E.totalAddComm

/-- The full gerbe provenance package for Theorem 38.1
(`W31-thm:terminal-unipotent-gerbe-provenance`).

Bundles the classifying map, the pullback identity, and the unipotent
extension into concrete operation-level provenance data.
This provides checkable structure (31 coordinates with the
`x^{(30)}, λ_*` profile, the three-way class identity, and the
order-31 extension kernel) alongside the previous `provenanceFor`
predicate, which is retained for the background-level provenance claim.
Note: the `UnipotentExtension` here models the group extension
`U → Ū` (unipotent central extension with μ₃₁ kernel); the gerbe
projection `G_f → X_*` is a separate geometric structure not formalized
here (no algebraic stacks in Mathlib). An order-31 kernel is necessary
but not sufficient for a μ₃₁-gerbe — the stack structure remains background.
-/
structure GerbeProvenance where
  /-- The classifying morphism with its coordinate profile. -/
  classifying : ClassifyingMap
  /-- The pointed pullback identity. -/
  pullback : PullbackIdentity
  /-- The `μ_{31}`-gerbe as a unipotent central extension. -/
  extension : UnipotentExtension
  /-- The extension's base is the classifying map's source. -/
  base_eq : extension.base = classifying.source

/-- Carrier-level `μ_{31}` content only: the extension's kernel generator
has exact additive order 31. This is a single order-31 element, not the
operation-level algebraic `μ_{31}`-gerbe (no group extension, no band
action laws, no classifying/pullback operation). -/
theorem GerbeProvenance.isMu31 (P : GerbeProvenance) :
    addOrderOf P.extension.kernelGen = 31 :=
  P.extension.kernelOrder

/-- The three class identities compose: the pullback class equals the
Chern class. -/
theorem PullbackIdentity.pullback_eq_chern (P : PullbackIdentity) :
    P.pullbackClass = P.c1_31_Q5 :=
  P.pullback_eq.trans P.kappa_eq_chern

end SelmerCartanMotiveTowers
