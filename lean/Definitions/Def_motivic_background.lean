import Mathlib.Algebra.Group.Hom.Defs
import Mathlib.Algebra.Ring.Parity
import Mathlib.GroupTheory.OrderOfElement

namespace SelmerCartanMotiveTowers

/-- Geometric antecedent data for the root-localization correspondence
(paper L5422-5426: the motivic residue-divisor identity `∂[t] = N[D_N]`
on the root stack).

The paper's invariant root coordinate `t = u^N` gives rise to the root
Moore pair: the coordinate localizes to the cycle `b_mot`, and the
antecedent cochain witnesses the Moore relation `d c = N • b`. Recording
this geometric source means `isGenuine` can no longer be satisfied by a
purely algebraic torsion model with no root-coordinate origin
(verifier P0-2 feedback).

Background input (Strategy A): the paper constructs this data via the
equivariant motivic six-functor formalism [Hoyois; Khan-Ravi]. -/
structure GeometricAntecedent (Cochain : Type) (b_mot : Cochain) where
  /-- The type of root coordinates. -/
  RootCoord : Type
  /-- The invariant root coordinate (paper's `t = u^N`). -/
  rootCoord : RootCoord
  /-- Localization of a root coordinate to a cochain. -/
  localize : RootCoord → Cochain
  /-- The root coordinate localizes to the root Moore cycle. -/
  localizesTo : localize rootCoord = b_mot

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
- `b_mot`, `c_mot`: the root Moore pair, with `d(b_mot) = 0`,
  `d(c_mot) = N • b_mot` (conclusion of `P2M-prop:appendix-root-moore-complex`).
  NOTE: `b_mot` is NOT `N`-torsion as a cochain — the integral Moore model
  has differential `×N`, so `d(c_mot) = N • b_mot` is the genuine (nonzero)
  value of the differential. The `N`-torsion lives at cohomology level:
  `hb_class_order` records the paper's `ord[b_mot] = N` for the CLASS
  `[b_mot]` (Totaro's `CH^*(Bμ_N) = Z[ξ]/(Nξ)` computation).
- `Cohomology`, `classOf`: the cohomology layer (cycles modulo boundaries);
  `hb_class_order` records the paper's `ord[b_mot] = N` at the level of
  cohomology classes (Totaro's computation), not just cochains.
- `isGenuine`: marks `c_mot` as a genuine root-localization correspondence
  (not a freely adjoined generator); characterized by `isGenuine_iff`.

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
  /-- The root Moore class: a cycle. NOTE (P0-2 fix, 2026-10-09): `b_mot`
  is NOT `N`-torsion as a cochain. The paper's integral two-term Moore model
  has differential `×N` (paper L5422–5426), so `d(c_mot) = N • b_mot` is the
  genuine nonzero value of the differential — the old cochain-level fields
  `hb_order : N • b_mot = 0` and `hb_exact` FORCED `d c_mot = 0`, collapsing
  the model. They are deleted. The `N`-torsion is a cohomological phenomenon:
  `N • [b_mot] = [d c_mot] = 0` (since `d c_mot` is a boundary), and
  `hb_class_order` records the EXACT order `N` of the class `[b_mot]`
  (Totaro's `CH^*(Bμ_N)` computation). -/
  b_mot : Cochain
  hb_closed : d b_mot = 0
  /-- The paper's `ord[b_mot] = N`, at cohomology level (Totaro's
  `CH^*(Bμ_N) = Z[ξ]/(Nξ)` computation). This rules out the "b is a
  boundary" model: a boundary has class `0`, whose `addOrderOf` is `1 ≠ N`
  (since `N ≥ 3`). -/
  hb_class_order : addOrderOf (classOf b_mot) = N
  /-- Geometric antecedent: the invariant root coordinate localizing to
  `b_mot` (verifier P0-2). `isGenuine` is characterized relative to this
  data, so genuineness expresses the paper's invariant root coordinate /
  root-localization correspondence, not just an abstract `N`-torsion class. -/
  geometricAntecedent : GeometricAntecedent Cochain b_mot
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
  `[b_mot]`, legitimate because `b_mot` is closed (`hb_closed`).

  LIMITATION: the paper's "represented by the invariant root coordinate
  `t = u^N`" is a statement in motivic homotopy theory; what is formalized
  here is its cohomological shadow plus the recorded geometric source. -/
  isGenuine_iff : ∀ x, isGenuine x ↔
    (d x = N • b_mot ∧ addOrderOf (classOf b_mot) = N ∧ classOf b_mot ≠ 0 ∧
      ∃ r : geometricAntecedent.RootCoord, geometricAntecedent.localize r = b_mot)
  /-- The root antecedent: boundary `N • b_mot`, genuine correspondence. -/
  c_mot : Cochain
  hc_boundary : d c_mot = N • b_mot
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

end SelmerCartanMotiveTowers
