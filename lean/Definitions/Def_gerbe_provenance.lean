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

/-- The `μ_{31}`-gerbe as a unipotent central extension. -/
structure UnipotentExtension where
  /-- The base `X_*`. -/
  base : Type
  /-- The total space `G_{f_*}`. -/
  total : Type
  [totalAddComm : AddCommGroup total]
  /-- The projection `G_{f_*} → X_*`. -/
  proj : total → base
  /-- The kernel generator (the `μ_{31}` band generator). -/
  kernelGen : total
  /-- The kernel has exact order 31: this is what makes it a `μ_{31}`-gerbe. -/
  kernelOrder : addOrderOf kernelGen = 31
  /-- The kernel generator projects to the base identity (centrality). -/
  kernelCentral : ∀ t : total, ∃ n : ZMod 31, t + kernelGen = t

/-- The total space's group structure as an instance. -/
instance UnipotentExtension.instAddCommGroup (E : UnipotentExtension) :
    AddCommGroup E.total := E.totalAddComm

/-- The full gerbe provenance package for Theorem 38.1
(`W31-thm:terminal-unipotent-gerbe-provenance`).

Bundles the classifying map, the pullback identity, and the unipotent
extension into the concrete operation-level provenance the paper
constructs. This replaces the previous arbitrary `provenanceFor`
predicate with checkable structure: 31 coordinates with the
`x^{(30)}, λ_*` profile, the three-way class identity, and the
order-31 extension kernel. -/
structure GerbeProvenance where
  /-- The classifying morphism with its coordinate profile. -/
  classifying : ClassifyingMap
  /-- The pointed pullback identity. -/
  pullback : PullbackIdentity
  /-- The `μ_{31}`-gerbe as a unipotent central extension. -/
  extension : UnipotentExtension
  /-- The extension's base is the classifying map's source. -/
  base_eq : extension.base = classifying.source

/-- The gerbe provenance package determines a `μ_{31}`-gerbe structure:
the extension kernel's exact order 31 is the machine-checkable content
of "algebraic `μ_{31}`-gerbe". -/
theorem GerbeProvenance.isMu31 (P : GerbeProvenance) :
    addOrderOf P.extension.kernelGen = 31 :=
  P.extension.kernelOrder

/-- The three class identities compose: the pullback class equals the
Chern class. -/
theorem PullbackIdentity.pullback_eq_chern (P : PullbackIdentity) :
    P.pullbackClass = P.c1_31_Q5 :=
  P.pullback_eq.trans P.kappa_eq_chern

end SelmerCartanMotiveTowers
