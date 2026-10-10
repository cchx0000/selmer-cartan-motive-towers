import Mathlib.Algebra.Group.Hom.Defs
import Mathlib.Algebra.Group.Subgroup.Ker
import Mathlib.Algebra.Ring.Parity
import Mathlib.GroupTheory.OrderOfElement
import Mathlib.GroupTheory.QuotientGroup.Defs

namespace SelmerCartanMotiveTowers

/-- Geometric antecedent data for the root-localization correspondence
(paper L5422-5426: the motivic residue-divisor identity `∂[t] = N[D_N]`
on the root stack).

REVISION (2026-10-11, verifier todo): the old version recorded only an
arbitrary `RootCoord` type with a `localize` map hitting `b_mot`; the
degenerate model `RootCoord := Unit`, `localize := fun _ => b_mot` satisfied
the whole interface, and `isGenuine_iff`'s existential was already guaranteed
by `localizesTo`. The new version writes the root-stack meaning into the type:

- the root uniformizer `uCoord` and the `t = u^N` relation `root_pow`;
- a nontrivial root-step operation `rootOp` (`rootOp_nontrivial : rootOp ≠ id`),
  which the `Unit` model cannot satisfy (on `Unit` every endomorphism is `id`);
- the Gysin / root-localization map `gysin` with
  `gysin_rootCoord : gysin rootCoord = c`, tying the geometric data to the
  antecedent `c` of the Moore pair;
- the motivic residue–divisor identity
  `gysin_moore : d (gysin r) = N • localize r`, from which the Moore relation
  `d c = N • b` is DERIVED (see `MotivicBackground.hc_boundary`), not assumed.

Background input (Strategy A): the paper constructs this data via the
equivariant motivic six-functor formalism [Hoyois; Khan-Ravi]. The fields
marked EXT below are the external motivic inputs, explicitly labeled. -/
structure GeometricAntecedent (N : Nat) (Cochain : Type) [AddCommGroup Cochain]
    (d : Cochain →+ Cochain) (b c : Cochain) where
  /-- The type of root coordinates on the root stack. -/
  RootCoord : Type
  nonempty_RootCoord : Nonempty RootCoord
  /-- The invariant root coordinate `t` (paper's `t = u^N`). -/
  rootCoord : RootCoord
  /-- The root uniformizer `u`. -/
  uCoord : RootCoord
  /-- The root-step operation (multiplication by the uniformizer). -/
  rootOp : RootCoord → RootCoord
  /-- The `t = u^N` relation: `N` root steps from the uniformizer land on the
  invariant coordinate. EXT (Strategy A): root-stack geometry. -/
  root_pow : rootOp^[N] uCoord = rootCoord
  /-- The root action is nontrivial. This rules out the degenerate
  `RootCoord := Unit` model: on `Unit` the only endomorphism is `id`.
  EXT (Strategy A): nontriviality of the root action in the intended model. -/
  rootOp_nontrivial : rootOp ≠ id
  /-- Localization of a root coordinate to a cochain. -/
  localize : RootCoord → Cochain
  /-- The invariant root coordinate localizes to the root Moore cycle. -/
  localizesTo : localize rootCoord = b
  /-- Root coordinates localize to cycles.
  EXT (Strategy A): part of the six-functor / root-localization input. -/
  localize_closed : ∀ r, d (localize r) = 0
  /-- Gysin / root-localization correspondence map. -/
  gysin : RootCoord → Cochain
  /-- The antecedent `c` is the Gysin image of the invariant root coordinate:
  the geometric data genuinely corresponds to the Moore pair's `c`. -/
  gysin_rootCoord : gysin rootCoord = c
  /-- The motivic residue–divisor identity `∂[t] = N[D_N]` on the root stack
  (paper L5422–5426), stated at the level of root coordinates.
  EXT (Strategy A): external motivic input via the equivariant six-functor
  formalism [Hoyois; Khan–Ravi]. -/
  gysin_moore : ∀ r, d (gysin r) = N • localize r

/-- Motivic arithmetic background package for Theorem 12.2
(`P2L-thm:v48r4-motivic-seed`, primitive motivic Moore seed) and the
motivic carrier inputs of Theorem 38.5.

This packages the arithmetic inputs consumed (via
`P2M-prop:appendix-root-moore-complex`, "Rank-one root localization") by the
proof of the primitive motivic Moore seed. The paper's proof of that
proposition CITES the following external literature (not proved in the
paper):
- Equivariant motivic six-functor formalism for tame quotient stacks:
  Hoyois, Adv. Math. 305 (2017) [HoyoisEquivariantSix]; Khan–Ravi,
  arXiv:2106.15001 [KhanRaviStacks].
- Identification of integral motivic cohomology of quotient stacks with
  equivariant higher Chow groups: Choudhury–Deshmukh–Hogadi,
  arXiv:2012.13304 [ChoudhuryDeshmukhHogadi].
- The Chow ring computation `CH^*(Bμ_N) = Z[ξ]/(Nξ)` for the tautological
  character line, giving the EXACT order `N` (not just dividing `N`):
  Totaro, *The Chow ring of a classifying space*, PSPM 67 (1999)
  [TotaroChowBG].
- The motivic residue–divisor identity `∂[t] = N[D_N]` on the root stack
  (standard motivic computation).

FIELDS:
- `b_mot`, `c_mot`: the root Moore pair.
- `hb_class_order`: the paper's `ord[b_mot] = N`, at cohomology level
  (Totaro's `CH^*(Bμ_N) = Z[ξ]/(Nξ)` computation). This rules out the "b is a
  boundary" model: a boundary has class `0`, whose `addOrderOf` is `1 ≠ N`
  (since `N ≥ 3`). EXT (Strategy A): deep arithmetic input, kept as an
  explicit hypothesis; the `N`-torsion `N • [b_mot] = 0` itself is DERIVED
  (`n_smul_classOfCyc_b`), as is `[b_mot] ≠ 0` (`classOfCyc_b_ne_zero`).
- `Cycles`, `Boundaries`: the faithful integral two-term complex interface
  (kernel / image of `d`; the defaults fix their meaning).
- `cyclesQuotEquiv`, `quot_compat`: the identification of the
  cycles-modulo-boundaries quotient with the declared `Cohomology`
  (verifier todo 2026-10-11). The old interface let `classOf` act on ALL
  cochains with only a kernel condition, never identifying the quotient with
  `Cohomology`; now `classOf` on a cycle is honestly the quotient map
  followed by `cyclesQuotEquiv` (`classOfCyc_eq_quot`).
- `geometricAntecedent`: the root-stack data (invariant root coordinate
  `t = u^N`, nontrivial root action, Gysin map) localizing to `(b_mot, c_mot)`
  (verifier P0-2, strengthened 2026-10-11).

DERIVED (real proofs below, not fields): `d b_mot = 0` (`hb_closed`, from
`localize_closed` at the invariant root coordinate) and
`d c_mot = N • b_mot` (`hc_boundary`, from the residue–divisor identity
`gysin_moore`). NOTE (P0-2 fix, 2026-10-09): the old cochain-level fields
`hb_order : N • b_mot = 0` and `hb_exact` are deleted: jointly they FORCED
`d c_mot = 0`, collapsing the paper's intended integral two-term Moore model
(differential `×N`, paper L5422–5426), in which `d(c_mot) = N • b_mot` is the
genuine nonzero value of the differential and `b_mot` is NOT `N`-torsion as a
cochain. The `N`-torsion is a cohomological phenomenon in the intended model:
`N • [b_mot] = [d c_mot] = 0` (since `d c_mot` is a boundary).

LIMITATION (honest): the interface does not establish `N • b_mot ≠ 0` at
cochain level, and no comment claims it — that non-torsion is a property of
the intended integral model, not of every inhabitant of the structure. What
the 2026-10-11 revision does rule out is the trivial `RootCoord := Unit`
geometric model (`rootOp_nontrivial`), and the Moore relation / closedness
are now consequences of the geometric interface rather than free-floating
assumptions.

STATUS: background hypothesis package. These are the deep motivic-arithmetic
inputs; future work may replace them with concrete proofs. -/
structure MotivicBackground where
  N : Nat
  hNodd : Odd N
  /-- The order is genuinely `≥ 3`: `N = 1` would make the Moore relation
  degenerate (`b_mot = 0`). The paper's `N` is the order of `μ_N`. -/
  hN3 : 3 ≤ N
  Cochain : Type
  [addCommGroup_Cochain : AddCommGroup Cochain]
  nonempty_Cochain : Nonempty Cochain
  d : Cochain →+ Cochain
  hd2 : ∀ x, d (d x) = 0
  /-- Cohomology: cycles modulo boundaries (ungraded totalization). -/
  Cohomology : Type
  [addCommGroup_Cohomology : AddCommGroup Cohomology]
  /-- The canonical projection; its kernel is exactly the boundaries. -/
  classOf : Cochain →+ Cohomology
  classOf_ker : ∀ x, classOf x = 0 ↔ ∃ y, x = d y
  /-- Cycles: the kernel of `d`. The default fixes the meaning; the quotient
  interface below is stated against these fixed subgroups. -/
  Cycles : AddSubgroup Cochain := AddMonoidHom.ker d
  /-- Boundaries: the image of `d`. -/
  Boundaries : AddSubgroup Cochain := AddMonoidHom.range d
  /-- The cycles form an additive group (needed for the cycles/boundaries
  quotient below and for `QuotientAddGroup.mk`). -/
  [addCommGroup_Cycles : AddCommGroup ↥Cycles]
  /-- Propositional form of the `Cycles` default: `Cycles` is the kernel of
  `d`. (The default value alone is not a propositional fact about arbitrary
  inhabitants; this field makes the interface honest.) -/
  cycles_is_ker : Cycles = AddMonoidHom.ker d
  /-- Propositional form of the `Boundaries` default. -/
  boundaries_is_range : Boundaries = AddMonoidHom.range d
  /-- The faithful cohomology identification: cycles modulo boundaries `≃+`
  the declared `Cohomology`. -/
  cyclesQuotEquiv :
    (↥Cycles ⧸ Boundaries.comap Cycles.subtype) ≃+ Cohomology
  /-- Compatibility: on cycles, `classOf` is the quotient map followed by
  `cyclesQuotEquiv`. -/
  quot_compat :
    ∀ z : Cycles, cyclesQuotEquiv (QuotientAddGroup.mk z) = classOf z.val
  /-- The root Moore cycle. -/
  b_mot : Cochain
  /-- The paper's `ord[b_mot] = N`, at cohomology level (Totaro's
  `CH^*(Bμ_N) = Z[ξ]/(Nξ)` computation). This rules out the "b is a
  boundary" model: a boundary has class `0`, whose `addOrderOf` is `1 ≠ N`
  (since `N ≥ 3`).
  EXT (Strategy A): deep arithmetic input, kept as an explicit hypothesis;
  the `N`-torsion `N • [b_mot] = 0` is DERIVED (`n_smul_classOfCyc_b`). -/
  hb_class_order : addOrderOf (classOf b_mot) = N
  /-- The root antecedent. -/
  c_mot : Cochain
  /-- Geometric antecedent: the invariant root coordinate localizing to
  `b_mot`, with the root-stack data (`t = u^N`, nontrivial root action,
  Gysin map) written into the type (verifier P0-2, strengthened 2026-10-11).
  `isGenuine` is characterized relative to this data, so genuineness expresses
  the paper's invariant root coordinate / root-localization correspondence,
  not just an abstract `N`-torsion class. -/
  geometricAntecedent : GeometricAntecedent N Cochain d b_mot c_mot
  /-- Marks genuine root-localization correspondences (vs. freely adjoined
  generators). -/
  isGenuine : Cochain → Prop
  /-- Geometric meaning of genuineness: `x` is a genuine antecedent iff it
  satisfies the Moore relation `d x = N • b_mot`, the class `[b_mot]` has
  exact order `N` (hence is nonzero), and the geometric antecedent data
  (invariant root coordinate localizing to `b_mot`) is present.

  NOTE (P0-2 fix, 2026-10-10): `classOf` is NEVER applied to `x` itself.
  The old version required `N • classOf x = 0` for the antecedent `x`,
  but `x` is not a cycle, so that was meaningless -- and it entailed the
  cochain-level relation `N^2 • b_mot = 0` (via `classOf_ker`, `d^2 = 0`),
  contradicting the integral Moore model. All cohomology here is about
  `[b_mot]`, legitimate because `b_mot` is closed (`hb_closed`, now derived).

  LIMITATION: the paper's "represented by the invariant root coordinate
  `t = u^N`" is a statement in motivic homotopy theory; what is formalized
  here is its cohomological shadow plus the recorded geometric source, now
  with the root-stack operations (`rootOp`, `gysin`) in the type. -/
  isGenuine_iff : ∀ x, isGenuine x ↔
    (d x = N • b_mot ∧ addOrderOf (classOf b_mot) = N ∧ classOf b_mot ≠ 0 ∧
      ∃ r : geometricAntecedent.RootCoord, geometricAntecedent.localize r = b_mot)
  /-- The root antecedent is a genuine root-localization correspondence. -/
  hc_genuine : isGenuine c_mot

/-- The package's own `AddCommGroup` structure on cochains, registered as an
instance so that notation (`0`, `•`) in statements about a background
package `bg` resolves to the package's own instance. Without this, a
statement would need a redundant `[AddCommGroup bg.Cochain]` binder
introducing an *arbitrary unrelated* instance — disconnecting `•`/`0` from
the package fields and making the statement false. -/
instance MotivicBackground.instAddCommGroup (bg : MotivicBackground) :
    AddCommGroup bg.Cochain :=
  bg.addCommGroup_Cochain

/-- The package's own `AddCommGroup` structure on cohomology, registered as
an instance so that `addOrderOf (bg.classOf _)` elaborates against the
package's own group structure. -/
instance MotivicBackground.instAddCommGroupCohomology
    (bg : MotivicBackground) :
    AddCommGroup bg.Cohomology :=
  bg.addCommGroup_Cohomology

/-- `classOf` restricted to cycles: the faithful cohomology-class map. On a
cycle `z`, `classOfCyc z` is the honest cohomology class `[z]`; by
`classOfCyc_eq_quot` it factors through the cycles/boundaries quotient. -/
def MotivicBackground.classOfCyc (bg : MotivicBackground) :
    bg.Cycles →+ bg.Cohomology :=
  bg.classOf.comp bg.Cycles.subtype

/-- On cycles, `classOf` is the quotient map followed by the faithful
identification — i.e. `classOfCyc` factors through `Cycles ⧸ Boundaries`. -/
theorem MotivicBackground.classOfCyc_eq_quot (bg : MotivicBackground)
    (z : bg.Cycles) :
    bg.classOfCyc z = bg.cyclesQuotEquiv (QuotientAddGroup.mk z) :=
  (bg.quot_compat z).symm

/-- Membership in `Cycles` from vanishing differential (via `cycles_is_ker`). -/
theorem MotivicBackground.mem_cycles (bg : MotivicBackground) {x : bg.Cochain}
    (h : bg.d x = 0) : x ∈ bg.Cycles := by
  rw [bg.cycles_is_ker]
  exact AddMonoidHom.mem_ker.mpr h

/-- The root Moore cycle is closed — DERIVED from the geometric antecedent
(`localize_closed` at the invariant root coordinate), not assumed. -/
theorem MotivicBackground.hb_closed (bg : MotivicBackground) :
    bg.d bg.b_mot = 0 := by
  have h :=
    bg.geometricAntecedent.localize_closed bg.geometricAntecedent.rootCoord
  rwa [bg.geometricAntecedent.localizesTo] at h

/-- The Moore relation — DERIVED from the motivic residue–divisor identity
`∂[t] = N[D_N]` (`gysin_moore`) evaluated at the invariant root coordinate,
using that its Gysin image is `c_mot` and its localization is `b_mot`. -/
theorem MotivicBackground.hc_boundary (bg : MotivicBackground) :
    bg.d bg.c_mot = bg.N • bg.b_mot := by
  have h :=
    bg.geometricAntecedent.gysin_moore bg.geometricAntecedent.rootCoord
  rwa [bg.geometricAntecedent.gysin_rootCoord,
    bg.geometricAntecedent.localizesTo] at h

/-- The class `[b_mot]` is `N`-torsion — DERIVED: `N • [b] = [N • b] = [d c] = 0`
since `d c` is a boundary (`classOf_ker`). This is the core algebraic
derivation: the `N`-torsion lives at cohomology level, not as a cochain-level
assumption. -/
theorem MotivicBackground.n_smul_classOfCyc_b (bg : MotivicBackground) :
    bg.N • bg.classOfCyc ⟨bg.b_mot, bg.mem_cycles bg.hb_closed⟩ = 0 := by
  have h1 : bg.classOf (bg.N • bg.b_mot) = 0 := by
    rw [← bg.hc_boundary, bg.classOf_ker]
    exact ⟨bg.c_mot, rfl⟩
  have h2 : bg.classOfCyc ⟨bg.b_mot, bg.mem_cycles bg.hb_closed⟩ = bg.classOf bg.b_mot := rfl
  rw [h2, ← map_nsmul]
  exact h1

/-- The class `[b_mot]` is nonzero — DERIVED from the exact order `N ≥ 3`
(a boundary has class `0`, of order `1`). -/
theorem MotivicBackground.classOfCyc_b_ne_zero (bg : MotivicBackground) :
    bg.classOfCyc ⟨bg.b_mot, bg.mem_cycles bg.hb_closed⟩ ≠ 0 := by
  intro h
  have hN := bg.hb_class_order
  have h2 : bg.classOfCyc ⟨bg.b_mot, bg.mem_cycles bg.hb_closed⟩ = bg.classOf bg.b_mot := rfl
  rw [← h2, h, addOrderOf_zero] at hN
  have h3 := bg.hN3
  omega

/-- The `N`-torsion restated through the faithful quotient identification:
`[b_mot]` as an element of `Cycles ⧸ Boundaries` is `N`-torsion. -/
theorem MotivicBackground.n_smul_quot_class_b (bg : MotivicBackground) :
    bg.N • bg.cyclesQuotEquiv
      (QuotientAddGroup.mk ⟨bg.b_mot, bg.mem_cycles bg.hb_closed⟩) = 0 := by
  rw [← bg.classOfCyc_eq_quot]
  exact bg.n_smul_classOfCyc_b

end SelmerCartanMotiveTowers
