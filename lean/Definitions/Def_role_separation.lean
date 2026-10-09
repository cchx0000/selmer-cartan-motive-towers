import Definitions.Def_finite_ordered_support
import Definitions.Def_motivic_moore_reedy

namespace SelmerCartanMotiveTowers

/-- A nonzero closed degree-zero control morphism between role objects.

The paper (`P2M-def:role-separated-objectification`,
`P2M-eq:objectified-control-edge`) defines `λ_{ij}^{sel} :
d_{q_i}^{sel}(S) → e_{q_j}^{sel}(S)` as zero on every summand except the
`(i,j)`-summand, where it is the restriction of the Boolean correspondence
`U_{q_i}`. It is a *nonzero* morphism (the `(i,j)`-summand is nonzero).

In our discrete model, a control morphism has a source and target in
`Role`, and nonzeroness is witnessed by `src ≠ tgt` (a zero morphism would
have no distinct source/target to act between). "Closed degree-zero" is
automatic in the discrete model (no differential to be closed under, no
grading shift). -/
structure ControlEdge (Role : Type) where
  src : Role
  tgt : Role
  nonzero : src ≠ tgt

/-- Role-separated controller/birth data over a finite ordered support.

Packages the paper's `P2M-def:role-separated-objectification`:
- `Role`: the type of role objects (controllers + births).
- `d e`: the controller family `d_{q_i}^{sel}` and birth family
  `e_{q_j}^{sel}`, indexed by `Fin S.primes.card`.
- `separated`: controller/birth separation — the images of `d` and `e`
  are disjoint. This is the structural content of "role-separated":
  no object is both a controller and a birth. In particular the families
  `d` and `e` are distinct.
- `hasEdge i j`: the paper's marking — a distinguished control edge from
  `d i` to `e j` exists exactly for `i < j`.
- `edgeWitnessed`: every marked edge is witnessed by an actual nonzero
  `ControlEdge` (structural, not a free predicate).

This replaces the free predicates `isSeparated` / `controlMarked` of the
earlier formalization: separation is a real disjointness property (not
`fun _ => True`), and edges are witnessed by `ControlEdge` data. -/
structure RoleSeparation (S : finite_ordered_support) where
  Role : Type
  d : Fin S.primes.card → Role
  e : Fin S.primes.card → Role
  separated : ∀ i j, d i ≠ e j
  hasEdge : Fin S.primes.card → Fin S.primes.card → Prop
  edge_marked : ∀ i j, hasEdge i j ↔ i.val < j.val
  edgeWitnessed : ∀ i j, hasEdge i j → ∃ m : ControlEdge Role, m.src = d i ∧ m.tgt = e j

/-- The canonical role separation: `Role = Fin card ⊕ Fin card`,
`d = Sum.inl`, `e = Sum.inr`. The images are disjoint by `Sum.inl_ne_inr`.
Edges are marked exactly for `i < j`; each marked edge is witnessed by the
explicit `ControlEdge` with `src = Sum.inl i`, `tgt = Sum.inr j`
(nonzero since `Sum.inl i ≠ Sum.inr j`). -/
def canonicalRoleSeparation (S : finite_ordered_support) : RoleSeparation S where
  Role := Fin S.primes.card ⊕ Fin S.primes.card
  d := Sum.inl
  e := Sum.inr
  separated := fun i j => Sum.inl_ne_inr
  hasEdge := fun i j => i.val < j.val
  edge_marked := fun i j => Iff.rfl
  edgeWitnessed := fun i j h => ⟨⟨Sum.inl i, Sum.inr j, Sum.inl_ne_inr⟩, rfl, rfl⟩

/- Cutoff functoriality (paper item (iv)): NOT FORMALIZED.

The paper's (iv) states: under `S_r ⊂ S_{r+1}`, old birth objects and old
edges are retained, each old controller acquires precisely its new
`(i,r+1)`-summand, and the new controller has only its core summand;
projection back deletes exactly these new data; the maps are strict and
compose under further cutoff deletion.

This concerns the specific direct-sum decomposition (core summand +
labelled `(i,j)`-summands `B_{S_{<j} \ {q_i}}^{(i,j)}`), which our discrete
`Fin card ⊕ Fin card` model does not represent. Formalizing (iv) would
require the summand-level bookkeeping. We record it as uncovered. -/

end SelmerCartanMotiveTowers
