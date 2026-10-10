import Mathlib.Algebra.Group.Defs
import Mathlib.Algebra.Ring.Defs
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
coordinate data the paper's proof actually uses: the 31-tuple shape, the
`x^{(30)}, λ_*` profile, and — new per P1-5 M15 — the binding of the
morphism to its profile (`map_coords`): previously `map` and `coords`
were unrelated fields. -/
structure ClassifyingMap where
  /-- The source space `X_*`. HONEST SCOPE (P1-5 M15): a bare type — the
      geometric `X_*` is NOT required to carry a group structure. -/
  source : Type
  /-- The target classifying stack `BŪ_{32}^{cyc}`. -/
  target : Type
  /-- The classifying morphism itself. -/
  map : source → target
  /-- The 31 adjacent coordinates of the classifying morphism, as points of
      the target stack (paper L15832–15840: "whose first thirty adjacent
      coordinates are `x` and whose last adjacent coordinate is `λ_*`"). -/
  coords : Fin 31 → target
  /-- The base coordinate `x` (repeated 30 times). -/
  x : target
  /-- The terminal coordinate `λ_*`. -/
  lambda_star : target
  /-- First thirty coordinates are `x` (paper: "whose first thirty
      adjacent coordinates are `x`"). -/
  coord_eq : ∀ i : Fin 31, (i.val < 30) → coords i = x
  /-- Last coordinate is `λ_*` (paper: "whose last adjacent coordinate
      is `λ_*`"). -/
  last_coord : coords 30 = lambda_star
  /-- Adjacent-coordinate projections on the target stack. -/
  targetProj : Fin 31 → (target → target)
  /-- BINDING (P1-5 M15): the classifying morphism is recovered from its
      coordinate profile — the `i`-th adjacent coordinate of every value of
      `map` is the recorded profile value. This is the field that ties
      `map` to `coords`. -/
  map_coords : ∀ (s : source) (i : Fin 31), targetProj i (map s) = coords i

/-- The pointed pullback identity (paper L15841–15848,
`W31-eq:terminal-unipotent-pullback`):
`ρ̄_{f_*}^* ω_{31}^{univ} = (x^{(30)}, λ_*)_{ρ_{f_*}} = κ_5^{root} = c_1^{(31)}(Q_5)`.

The universal obstruction class `ω_{31}^{univ}` pulls back along the
classifying map to the Massey value `(x^{(30)}, λ_*)`, which the LLSWW
specialization identifies with the root Kummer class `κ_5^{root}`, which
in turn equals the 31-primary Chern class `c_1^{(31)}(Q_5)`.

Formalized at the level of `ZMod 31` values — and, new per P1-5 M15, with a
GENUINE pullback operation (`pullbackOp`, modelling `ρ̄_{f_*}^*` on
coefficients) and the actual pullback-square equation
(`pullback_square`), not a bare proposition label. The geometric pullback
on stacks remains background. -/
structure PullbackIdentity where
  /-- The universal obstruction class `ω_{31}^{univ}`, at `ZMod 31`
      coefficient level. -/
  univClass : ZMod 31
  /-- The GENUINE pullback operation `ρ̄_{f_*}^*` on `ZMod 31`-coefficients
      (paper L15841–15848). New per P1-5 M15: this is an actual operation
      field, not a label. -/
  pullbackOp : ZMod 31 → ZMod 31
  /-- The pulled-back class `ρ̄^* ω_{31}^{univ}`. -/
  pullbackClass : ZMod 31
  /-- The pullback-square equation: applying the pullback operation to the
      universal class yields the pulled-back class. The actual equation,
      not a bare `Prop` tag. -/
  pullback_square : pullbackOp univClass = pullbackClass
  /-- The coordinate Massey value `(x^{(30)}, λ_*)_{ρ_{f_*}}`. -/
  masseyValue : ZMod 31
  /-- `ρ̄^* ω_{31}^{univ} = (x^{(30)}, λ_*)`: the pullback equals the
      coordinate Massey value. -/
  pullback_eq_massey : pullbackClass = masseyValue
  /-- The root Kummer class `κ_5^{root} : ZMod 31`. -/
  kappa5root : ZMod 31
  /-- LLSWW specialization: `(x^{(30)}, λ_*) = κ_5^{root}`. -/
  massey_eq_kappa : masseyValue = kappa5root
  /-- The 31-primary Chern class `c_1^{(31)}(Q_5) : ZMod 31`. -/
  c1_31_Q5 : ZMod 31
  /-- `κ_5^{root} = c_1^{(31)}(Q_5)`: the Kummer class is the Chern class. -/
  kappa_eq_chern : kappa5root = c1_31_Q5
  /-- The common class is nonzero (it is the obstruction). -/
  class_nonzero : pullbackClass ≠ 0

/-- The unipotent central extension `1 → μ_{31} → U → Ū → 1` of
finite-étale group schemes (paper L15805–15820,
`W31-eq:twisted-unipotent-extension`), recorded with genuine
group/homomorphism/kernel/band-action structure.

DIRECTION (unified per P1-5 M15): the paper's exact sequence is
`1 → μ_{31} → U → Ū → 1`, so `U` is the TOTAL group and `Ū` the QUOTIENT;
the projection goes `U → Ū`. (The old text wrote `Ū → U` in the title
while the paragraph said `U → Ū`; both now read `U → Ū`.)

This is the GROUP-SCHEME central extension, DISTINGUISHED from the gerbe
projection `G_{f_*} → X_*` (paper L15852–15864), which is a separate
geometric structure not formalized here (no algebraic stacks in Mathlib).

HONEST SCOPE (P1-5 M15): this records the paper's abelianization-level
extension data — genuine homomorphism, surjectivity, two-sided kernel
identification, and band action laws are now present, but centrality is
automatic in an `AddCommGroup` and does NOT express a general non-abelian
unipotent central extension. This is NOT a verified algebraic
`μ_{31}`-gerbe: an order-31 kernel is necessary but not sufficient, and
the stack structure remains background. -/
structure UnipotentExtension where
  /-- The total group `U = U_{32}^{cyc}` (source of the surjection). -/
  total : Type
  [totalAddComm : AddCommGroup total]
  /-- The quotient group `Ū = Ū_{32}^{cyc} = U / Z_{31}`. -/
  quotient : Type
  [quotAddComm : AddCommGroup quotient]
  /-- The `μ_{31}`-band scalar action on the total group. -/
  [totalScalar : SMul (ZMod 31) total]
  /-- The projection `U → Ū`. New per P1-5 M15: stated as a homomorphism
      (`proj_add`) and a surjection (`proj_surjective`). -/
  proj : total → quotient
  /-- The kernel generator (the `μ_{31}` band generator). -/
  kernelGen : total
  /-- The kernel has exact order 31 (necessary for a `μ_{31}`-gerbe;
      the stack structure itself is background). -/
  kernelOrder : addOrderOf kernelGen = 31
  /-- `proj` is a group homomorphism. -/
  proj_add : ∀ a b : total, proj (a + b) = proj a + proj b
  /-- `proj` is surjective onto the quotient. -/
  proj_surjective : Function.Surjective proj
  /-- Band action law: identity. -/
  smul_one : ∀ t : total, (1 : ZMod 31) • t = t
  /-- Band action law: scalar additivity. -/
  smul_add : ∀ (m n : ZMod 31) (t : total), (m + n) • t = m • t + n • t
  /-- Band action law: compatibility of the `ZMod 31`-action with the
      natural `ℕ`-action. -/
  smul_nat : ∀ (n : ZMod 31) (t : total), n • t = n.val • t
  /-- Band/projection compatibility: the projection intertwines the band
      action with the `ℕ`-action on the quotient. -/
  proj_smul : ∀ (n : ZMod 31) (t : total), proj (n • t) = n.val • proj t
  /-- The kernel generator projects to the quotient identity: it lies in
      the kernel of `proj`. -/
  projGenTrivial : proj kernelGen = 0
  /-- Forward kernel inclusion: the kernel of the projection is contained
      in the `ZMod 31`-multiples of the kernel generator. (The reverse
      inclusion is DERIVED below as `projKernelRev`.) -/
  projKernel : ∀ t : total, proj t = 0 → ∃ n : ZMod 31, t = n • kernelGen
  /-- Centrality: the kernel generator commutes with every total element.
      (Automatic in any `AddCommGroup`; recorded as the paper's
      abelianization-level centrality data.) -/
  kernelCentral : ∀ t : total, t + kernelGen = kernelGen + t

/-- A concrete model: the cyclic group `ZMod 31` over the point `ZMod 1`,
with band generator `1`.

Satisfiability evidence (author-reported; independent build coverage
pending per P0-3): the strengthened fields are jointly inhabited, so the
`UnipotentExtension` premise is not empty. This covers the extension layer
only — it does NOT supply the full `WitnessBackground`, its arithmetic
realization, or a genuine non-abelian central extension, and it must NOT be
read as the algebraic `μ_{31}`-gerbe itself (P1-5 M15). -/
def unipotentExtensionModel : UnipotentExtension where
  total := ZMod 31
  quotient := ZMod 1
  proj := fun _ => 0
  kernelGen := 1
  kernelOrder := ZMod.addOrderOf_one 31
  proj_add := fun _ _ => Subsingleton.elim _ _
  proj_surjective := fun b => ⟨0, Subsingleton.elim _ _⟩
  smul_one := fun t => by
    show (1 : ZMod 31) * t = t
    exact one_mul t
  smul_add := fun m n t => by
    show (m + n) * t = m * t + n * t
    exact add_mul m n t
  smul_nat := fun n t => by
    haveI : NeZero 31 := NeZero.mk (by decide)
    have h : ((n.val : ZMod 31)) = n := ZMod.natCast_zmod_val n
    show n * t = n.val • t
    calc n * t = ((n.val : ZMod 31)) * t := by rw [h]
      _ = n.val • t := by rw [nsmul_eq_mul]
  proj_smul := fun _ _ => Subsingleton.elim _ _
  projGenTrivial := Subsingleton.elim _ _
  projKernel := fun t _ => ⟨t, by rw [show t • (1 : ZMod 31) = t * 1 from rfl, mul_one]⟩
  kernelCentral := fun t => add_comm t 1

/-- The total space's group structure as an instance. -/
instance UnipotentExtension.instAddCommGroup (E : UnipotentExtension) :
    AddCommGroup E.total := E.totalAddComm

/-- The `μ_{31}`-band scalar action as an instance (needed so `n • t`
    notation resolves in derived theorems). -/
instance UnipotentExtension.instScalar (E : UnipotentExtension) :
    SMul (ZMod 31) E.total := E.totalScalar

/-- The quotient's group structure as an instance. -/
instance UnipotentExtension.instAddCommGroupQuotient (E : UnipotentExtension) :
    AddCommGroup E.quotient := E.quotAddComm

/-- Reverse kernel inclusion (P1-5 M15): every `ZMod 31`-multiple of the
    generator lies in the kernel — derived from the homomorphism law
    `proj_add`, the band/projection compatibility `proj_smul`, and
    `projGenTrivial`. (`kernelOrder` pins the resulting cyclic subgroup at
    exact order 31.) -/
theorem UnipotentExtension.projKernelRev (E : UnipotentExtension) :
    ∀ n : ZMod 31, E.proj (n • E.kernelGen) = 0 := by
  intro n
  rw [E.proj_smul, E.projGenTrivial, nsmul_zero]

/-- Two-sided kernel identification (P1-5 M15): the kernel of `proj` is
    exactly the cyclic subgroup generated by `kernelGen` (of exact order
    31 by `kernelOrder`). Forward is the interface field `projKernel`;
    reverse is `projKernelRev` above. -/
theorem UnipotentExtension.kernelMem_iff (E : UnipotentExtension) (t : E.total) :
    E.proj t = 0 ↔ ∃ n : ZMod 31, t = n • E.kernelGen :=
  ⟨E.projKernel t, fun ⟨n, hn⟩ => hn ▸ E.projKernelRev n⟩

/-- The cartesian classifying/pullback square (paper L15852–15864,
`W31-eq:terminal-obstruction-gerbe`):
```
G_{f_*}  →  B U_{32}^{cyc}
  |              |
  v              v
 X_*   →   B Ū_{32}^{cyc}
          ρ̄
```
`G_{f_*} := X_* ×_{BŪ} B U` is the homotopy pullback, an algebraic
`μ_{31}`-gerbe with class `c_1^{(31)}(Q_5)`.

Recorded at the level of the formalized data — Mathlib has no algebraic
stacks, so `G_{f_*}` and `B U_{32}^{cyc}` are BACKGROUND types (their
construction is CITED, not verified): the bottom arrow is the classifying
morphism, the right arrow is induced by the unipotent extension's
projection, and the square COMMUTES — the actual commutativity equation,
not a bare label. Its class-level shadow is
`PullbackIdentity.pullback_square`. -/
structure ClassifyingPullbackSquare (C : ClassifyingMap) (E : UnipotentExtension) where
  /-- The homotopy pullback `G_{f_*}` (background: no algebraic stacks in
      Mathlib). -/
  gerbe : Type
  /-- The classifying stack `B U_{32}^{cyc}` of the total group
      (background). -/
  totalStack : Type
  /-- Left leg `G_{f_*} → X_*`. -/
  gerbeToSource : gerbe → C.source
  /-- Top leg `G_{f_*} → B U_{32}^{cyc}`. -/
  gerbeToTotal : gerbe → totalStack
  /-- Right leg `B U → B Ū`, induced by the extension projection. -/
  inducedMap : totalStack → C.target
  /-- The square commutes. -/
  square_comm : ∀ g : gerbe, inducedMap (gerbeToTotal g) = C.map (gerbeToSource g)

/-- The full gerbe provenance package for Theorem 38.1
(`W31-thm:terminal-unipotent-gerbe-provenance`).

Bundles the classifying map (with its `x^{(30)}, λ_*` coordinate profile
bound to the morphism), the pointed pullback identity (with the genuine
pullback operation and square equation), the unipotent central extension
`U → Ū` (paper L15805–15820) with its homomorphism/surjectivity/kernel/
band-action structure, and the cartesian classifying/pullback square
(paper L15832–15873) binding the classifying map to the extension
projection.

DISTINGUISHED (P1-5 M15): the `UnipotentExtension` here is the
GROUP-SCHEME central extension `1 → μ_{31} → U → Ū → 1`; the gerbe
projection `G_{f_*} → X_*` (L15852–15864) is a SEPARATE geometric
structure not formalized here (no algebraic stacks in Mathlib), and the
geometric `X_*` is not required to be a group. An order-31 kernel is
necessary but not sufficient for a `μ_{31}`-gerbe — the stack structure
remains background.

This provides checkable structure alongside the previous `provenanceFor`
predicate, which is RETAINED as an unbound background predicate (not
deleted, not tied to this data). -/
structure GerbeProvenance where
  /-- The classifying morphism with its coordinate profile. -/
  classifying : ClassifyingMap
  /-- The pointed pullback identity (genuine pullback operation + square
      equation). -/
  pullback : PullbackIdentity
  /-- The unipotent group extension `U → Ū` with order-31 kernel
      (paper L15805–15820; the group-scheme extension, distinct from the
      gerbe projection `G_{f_*} → X_*`). -/
  extension : UnipotentExtension
  /-- The cartesian classifying/pullback square binding the classifying map
      to the extension projection (paper L15832–15873). -/
  square : ClassifyingPullbackSquare classifying extension
  /-- NARROWED per P1-5 M15 (replaces the old `base_eq`): the old field
      `extension.base = classifying.source` equated the extension quotient
      TYPE with the classifying source TYPE by bare type equality — too
      strong to state as data, and it invited reading the geometric `X_*`
      as a group. Replaced by an explicit identification map, honestly
      labeled as ASSUMED interface data (NOT a verified identification);
      in particular the geometric `X_*` (`classifying.source`) is NOT
      required to carry a group structure. -/
  quotIdentification : extension.quotient → classifying.source

/-- Carrier-level `μ_{31}` content only: the extension's kernel generator
has exact additive order 31. HONEST SCOPE (P1-5 M15): this is a single
order-31 element, not the operation-level algebraic `μ_{31}`-gerbe — an
order-31 element (or the `ZMod 31`-over-`ZMod 1` local model) must NOT be
equated with the required algebraic `μ_{31}`-gerbe (no verified gerbe
projection, no stack structure). -/
theorem GerbeProvenance.isMu31 (P : GerbeProvenance) :
    addOrderOf P.extension.kernelGen = 31 :=
  P.extension.kernelOrder

/-- The pullback class equals the Kummer class (via the Massey leg). -/
theorem PullbackIdentity.pullback_eq_kappa (P : PullbackIdentity) :
    P.pullbackClass = P.kappa5root :=
  P.pullback_eq_massey.trans P.massey_eq_kappa

/-- The three class identities compose: the pullback class equals the
Chern class. -/
theorem PullbackIdentity.pullback_eq_chern (P : PullbackIdentity) :
    P.pullbackClass = P.c1_31_Q5 :=
  P.pullback_eq_kappa.trans P.kappa_eq_chern

/-- The pullback square composed with the class chain: pulling back the
universal class and running the identifications gives the Chern class. -/
theorem PullbackIdentity.square_eq_chern (P : PullbackIdentity) :
    P.pullbackOp P.univClass = P.c1_31_Q5 :=
  P.pullback_square.trans P.pullback_eq_chern

end SelmerCartanMotiveTowers
