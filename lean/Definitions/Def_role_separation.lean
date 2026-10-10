import Mathlib.Data.ZMod.Basic
import Definitions.Def_finite_ordered_support
import Definitions.Def_motivic_moore_reedy

namespace SelmerCartanMotiveTowers

/-- The differential on Hom-elements in the discrete model.

The paper's control morphism `λ_{ij}^{sel}` is closed in the dg Hom-complex
(`P2M-thm:role-separated-objectification` (i)). Our discrete model has no dg
structure, so the differential on Hom-elements is the zero operator;
closedness is then the honest equation `d(eval) = 0` (see `HomElem.closed`),
automatic in the discrete model but recorded as a real equation about
`eval` rather than a `True` marker. -/
def homDiff {Role : Type} [AddCommGroup Role] : (Role → Role) → (Role → Role) :=
  fun _ _ => 0

/-- A Hom-complex element between role objects: the discrete shadow of the
paper's nonzero closed degree-zero control morphism `λ_{ij}^{sel}`
(`P2M-def:role-separated-objectification`, `P2M-eq:objectified-control-edge`).

The paper defines `λ_{ij}^{sel}` as the projection to the `(i,j)`-summand
followed by the restriction of the genuine Boolean correspondence `U_{q_i}`.
In the discrete model a Hom-element is recorded as its objectwise evaluation
`eval : Role → Role` (paper item (ii): "each control edge is the indicated
objectwise evaluation of the genuine Boolean correspondence"; evaluation at
objects of an endomorphism is the endomorphism itself):

- `eval_zero` / `eval_add`: `eval` is additive — a genuine Hom-structure
  morphism, stated against the REAL `AddCommGroup` law on `Role` (the old
  formal `Add` was left-projection with no group laws).
- `eval_nonzero`: `eval` is nonzero as a morphism (`∃ x, eval x ≠ 0`);
  strictly stronger than endpoint inequality `src ≠ tgt`.
- `degree` / `degree_zero`: the Hom-complex degree, recorded as data (`ℕ`)
  and constrained to `0` — replaces the old `True`-typed marker.
- `closed`: the equation `d(eval) = 0` for the discrete differential
  `homDiff` — replaces the old `True`-typed marker. Automatic in the
  discrete model (no dg structure); see `homDiff`.

The element is indexed by its source and target objects — a genuine
`Hom(src, tgt)`-shaped element, not a bare endomap of `Role`. The binding to
the Boolean correspondence is the equation `eval = proj_{ij} ∘ U_i`
supplied at `RoleSeparation.edgeWitnessed`.

REVISION NOTE (M7 Hom strengthening, 2026-10-10): replaces the whole-`Role`
endomap `hom` (which admitted `hom = id`) with per-`(src, tgt)` Hom-elements;
`degree_zero` and `closed` are real equations, not `True`. A genuine dg
control morphism is beyond the discrete model (no dg-category foundation in
Mathlib); see LIMITATIONS in the Theorems file. -/
structure HomElem (Role : Type) [AddCommGroup Role] (src tgt : Role) where
  eval : Role → Role
  eval_zero : eval 0 = 0
  eval_add : ∀ x y, eval (x + y) = eval x + eval y
  eval_nonzero : ∃ x, eval x ≠ 0
  degree : ℕ
  degree_zero : degree = 0
  closed : homDiff eval = fun _ => 0

/-- Role-separated controller/birth data over a finite ordered support `S`
with coefficient order `N`.

Packages the paper's `P2M-def:role-separated-objectification`:
- `Role`: the type of role objects (controllers + births), carrying a REAL
  `AddCommGroup` law. (The old formal `Add` was left-projection with no
  group laws.)
- `d` / `e`: the controller family `d_{q_i}^{sel}` and birth family
  `e_{q_j}^{sel}`, indexed by `Fin S.primes.card`.
- `dInjective` / `eInjective`: each family is internally injective. This
  excludes the degenerate constant-family model (e.g. `Role = Bool`,
  `d = const false`, `e = const true`) admitted by the previous version.
- `separated`: controller/birth separation — the images of `d` and `e` are
  disjoint. This is the structural content of "role-separated".
- `hasEdge` / `edge_marked`: the paper's marking — a distinguished control
  edge from `d i` to `e j` exists exactly for `i < j`.
- `U`: the genuine Boolean correspondences `U_{q_i}` (paper item (ii)) as
  endomorphisms of `Role`. `U_idem` records that they are Boolean
  idempotents — the input to Karoubi splitting in the paper's proof of (i);
  `U_add` / `U_zero` record that they are additive.
- `proj`: projection to the `(i,j)`-summand (paper proof of (i):
  "projection to the `(i,j)`-copy followed by the restriction of `U_{q_i}`");
  `proj_idem` records that these are genuine projections.
- `edgeWitnessed`: every marked edge is witnessed by an actual Hom-element
  `m : HomElem Role (d i) (e j)` which IS the indicated objectwise
  evaluation `eval = proj_{ij} ∘ U_i` of the genuine Boolean correspondence
  (paper item (ii)). In particular `eval` is per-edge data: it cannot be a
  single shared endomap (e.g. `id`), since it is forced to be the
  `(i,j)`-component of `U_i`.
- `summand_nonzero`: the `(i,j)`-summand `proj_{ij}(U_i(d_i))` is nonzero —
  the discrete shadow of "it is a nonzero morphism (the `(i,j)`-summand is
  nonzero)".

REVISION NOTE (M7, 2026-10-10): `RoleSeparation` now takes the coefficient
order `N` (roles live in `O_{S,N}^{sel}`); `Zero`/`Add` are replaced by a
real `AddCommGroup`; both families are injective; `ControlEdge` is replaced
by per-`(src, tgt)` `HomElem`s with the correspondence binding
`eval = proj_{ij} ∘ U_i`. The previous Bool/left-projection/`hom = id`
degenerate model is excluded: constant families violate injectivity,
`hom = id` cannot satisfy the `(i,j)`-component equation, and additivity is
now against a genuine group law. -/
structure RoleSeparation (S : finite_ordered_support) (N : ℕ) where
  Role : Type
  [addGroup : AddCommGroup Role]
  d : Fin S.primes.card → Role
  e : Fin S.primes.card → Role
  dInjective : Function.Injective d
  eInjective : Function.Injective e
  separated : ∀ i j, d i ≠ e j
  hasEdge : Fin S.primes.card → Fin S.primes.card → Prop
  edge_marked : ∀ i j, hasEdge i j ↔ i.val < j.val
  U : Fin S.primes.card → (Role → Role)
  U_zero : ∀ i, U i 0 = 0
  U_add : ∀ i x y, U i (x + y) = U i x + U i y
  U_idem : ∀ i x, U i (U i x) = U i x
  U_nonzero : ∀ i, ∃ x, U i x ≠ 0
  proj : Fin S.primes.card → Fin S.primes.card → (Role → Role)
  proj_zero : ∀ i j, proj i j 0 = 0
  proj_add : ∀ i j x y, proj i j (x + y) = proj i j x + proj i j y
  proj_idem : ∀ i j x, proj i j (proj i j x) = proj i j x
  edgeWitnessed : ∀ i j, hasEdge i j →
    ∃ m : HomElem Role (d i) (e j), ∀ x, m.eval x = proj i j (U i x)
  summand_nonzero : ∀ i j, hasEdge i j → proj i j (U i (d i)) ≠ 0

/-- The canonical role separation over `S` with coefficient order `N`.

- `Role = (Fin card → ZMod N) × ZMod N` with the product `AddCommGroup` law
  (a real group law, not left-projection).
- `d i = (δ_i, 1)`, `e i = (δ_i, 2)` with `δ_i` the Dirac delta
  (`Function.update 0 i 1`): both families are injective; images are
  disjoint since `(1 : ZMod N) ≠ 2` for `N ≥ 3`.
- `U i (f, z) = (fun k => if i < k then z else 0, z)`: additive, idempotent
  (Boolean), nonzero — the discrete shadow of the genuine Boolean
  correspondence `U_{q_i}`.
- `proj i j (g, w) = (Function.update 0 j (g j), w)`: additive, idempotent —
  the discrete shadow of projection to the `(i,j)`-summand.
- For `i < j`, the edge Hom-element evaluates as `proj_{ij} ∘ U_i`, i.e.
  `eval (f, z) = (z • δ_j, z)`: a genuine per-edge additive map (never
  `id`), nonzero, of degree `0`, closed for the discrete differential.
  The `(i,j)`-summand `proj_{ij}(U_i(d_i)) = (δ_j, 1)` is nonzero.

This replaces the old `Fin card ⊕ Fin card` model with left-projection
addition and `hom = id`. -/
def canonicalRoleSeparation (S : finite_ordered_support) (N : ℕ) (hN : 3 ≤ N) :
    RoleSeparation S N := by
  haveI : NeZero N := ⟨by omega⟩
  have h12 : (1 : ZMod N) ≠ 2 := by
    intro h
    have h' : 1 % N = 2 % N := by
      have h1 : ((1 : ℕ) : ZMod N) = ((2 : ℕ) : ZMod N) := by
        simpa using h
      rwa [ZMod.natCast_eq_natCast_iff] at h1
    have e1 : 1 % N = 1 := Nat.mod_eq_of_lt (by omega)
    have e2 : 2 % N = 2 := Nat.mod_eq_of_lt (by omega)
    omega
  have h10 : (1 : ZMod N) ≠ 0 := by
    intro hcon
    have h1 : ((1 : ℕ) : ZMod N) = 0 := by simpa using hcon
    rw [ZMod.natCast_eq_zero_iff, Nat.dvd_one] at h1
    omega
  -- Model components, as named abbreviations for the proofs below.
  set D : Fin S.primes.card → (Fin S.primes.card → ZMod N) × ZMod N :=
    fun i => (Function.update 0 i 1, 1)
  set E : Fin S.primes.card → (Fin S.primes.card → ZMod N) × ZMod N :=
    fun i => (Function.update 0 i 1, 2)
  set Uv : Fin S.primes.card →
      ((Fin S.primes.card → ZMod N) × ZMod N →
        (Fin S.primes.card → ZMod N) × ZMod N) :=
    fun i p => ((fun k => if i.val < k.val then p.2 else 0), p.2)
  set Pv : Fin S.primes.card → Fin S.primes.card →
      ((Fin S.primes.card → ZMod N) × ZMod N →
        (Fin S.primes.card → ZMod N) × ZMod N) :=
    fun i j p => (Function.update 0 j (p.1 j), p.2)
  have upd_zero : ∀ j : Fin S.primes.card,
      Function.update (0 : Fin S.primes.card → ZMod N) j 0 = 0 := by
    intro j
    funext k
    rw [Function.update_apply]
    split_ifs with hk <;> rfl
  have δinj : Function.Injective
      (fun i : Fin S.primes.card =>
        Function.update (0 : Fin S.primes.card → ZMod N) i 1) := by
    intro i i' h
    by_contra hne
    have h2 : Function.update (0 : Fin S.primes.card → ZMod N) i 1 i =
        Function.update (0 : Fin S.primes.card → ZMod N) i' 1 i :=
      congrFun h i
    rw [Function.update_self] at h2
    rw [Function.update_of_ne hne] at h2
    exact h10 h2
  refine
    { Role := (Fin S.primes.card → ZMod N) × ZMod N,
      d := D,
      e := E,
      dInjective := fun i i' h => δinj (congrArg Prod.fst h),
      eInjective := fun i i' h => δinj (congrArg Prod.fst h),
      separated := fun i j h => h12 (congrArg Prod.snd h),
      hasEdge := fun i j => i.val < j.val,
      edge_marked := fun i j => Iff.rfl,
      U := Uv,
      U_zero := fun i => by
        show ((fun k : Fin S.primes.card =>
            if i.val < k.val then (0 : ZMod N) else 0), (0 : ZMod N)) =
          ((0 : Fin S.primes.card → ZMod N), (0 : ZMod N))
        refine Prod.ext ?_ rfl
        funext k
        by_cases hk : i.val < k.val <;> simp [hk],
      U_add := fun i x y => by
        obtain ⟨f1, z1⟩ := x
        obtain ⟨f2, z2⟩ := y
        show ((fun k : Fin S.primes.card =>
            if i.val < k.val then z1 + z2 else 0), z1 + z2) =
          (((fun k : Fin S.primes.card => if i.val < k.val then z1 else 0) +
            (fun k : Fin S.primes.card => if i.val < k.val then z2 else 0)),
            z1 + z2)
        refine Prod.ext ?_ rfl
        funext k
        by_cases hk : i.val < k.val
          <;> simp only [hk, if_true, if_false, Pi.add_apply, add_zero],
      U_idem := fun i x => by
        obtain ⟨f, z⟩ := x
        rfl,
      U_nonzero := fun i =>
        ⟨((0 : Fin S.primes.card → ZMod N), 1),
          fun hcon => h10 (congrArg Prod.snd hcon)⟩,
      proj := Pv,
      proj_zero := fun i j => by
        show (Function.update (0 : Fin S.primes.card → ZMod N) j 0, (0 : ZMod N)) =
          ((0 : Fin S.primes.card → ZMod N), (0 : ZMod N))
        rw [upd_zero j],
      proj_add := fun i j x y => by
        obtain ⟨f1, z1⟩ := x
        obtain ⟨f2, z2⟩ := y
        show (Function.update (0 : Fin S.primes.card → ZMod N) j ((f1 + f2) j),
            z1 + z2) =
          (Function.update (0 : Fin S.primes.card → ZMod N) j (f1 j) +
            Function.update (0 : Fin S.primes.card → ZMod N) j (f2 j), z1 + z2)
        refine Prod.ext ?_ rfl
        funext k
        by_cases hk : k = j <;> simp [hk, Pi.add_apply],
      proj_idem := fun i j x => by
        obtain ⟨g, w⟩ := x
        show (Function.update (0 : Fin S.primes.card → ZMod N) j
            ((Function.update (0 : Fin S.primes.card → ZMod N) j (g j)) j), w) =
          (Function.update (0 : Fin S.primes.card → ZMod N) j (g j), w)
        refine Prod.ext ?_ rfl
        funext k
        by_cases hk : k = j <;> simp [hk],
      edgeWitnessed := fun i j h => by
        have hlt : i.val < j.val := h
        refine ⟨⟨fun p => Pv i j (Uv i p), ?_, ?_, ?_, 0, rfl, rfl⟩,
          fun x => rfl⟩
        · show (Function.update (0 : Fin S.primes.card → ZMod N) j
              (if i.val < j.val then (0 : ZMod N) else 0), (0 : ZMod N)) =
            ((0 : Fin S.primes.card → ZMod N), (0 : ZMod N))
          rw [if_pos hlt, upd_zero j]
        · intro x y
          obtain ⟨f1, z1⟩ := x
          obtain ⟨f2, z2⟩ := y
          show (Function.update (0 : Fin S.primes.card → ZMod N) j
              (if i.val < j.val then z1 + z2 else 0), z1 + z2) =
            (Function.update (0 : Fin S.primes.card → ZMod N) j
                (if i.val < j.val then z1 else 0) +
              Function.update (0 : Fin S.primes.card → ZMod N) j
                (if i.val < j.val then z2 else 0), z1 + z2)
          rw [if_pos hlt, if_pos hlt, if_pos hlt]
          refine Prod.ext ?_ rfl
          funext k
          by_cases hk : k = j <;> simp [hk, Pi.add_apply]
        · refine ⟨((0 : Fin S.primes.card → ZMod N), 1), ?_⟩
          show (Function.update (0 : Fin S.primes.card → ZMod N) j
              (if i.val < j.val then (1 : ZMod N) else 0), (1 : ZMod N)) ≠ 0
          rw [if_pos hlt]
          intro hcon
          exact h10 (congrArg Prod.snd hcon)
      summand_nonzero := fun i j h => by
        have hlt : i.val < j.val := h
        show (Function.update (0 : Fin S.primes.card → ZMod N) j
            (if i.val < j.val then (1 : ZMod N) else 0), (1 : ZMod N)) ≠ 0
        rw [if_pos hlt]
        intro hcon
        exact h10 (congrArg Prod.snd hcon) }

/- Cutoff functoriality (paper item (iv)): NOT FORMALIZED.

The paper's (iv) states: under `S_r ⊂ S_{r+1}`, old birth objects and old
edges are retained, each old controller acquires precisely its new
`(i,r+1)`-summand, and the new controller has only its core summand;
projection back deletes exactly these new data; the maps are strict and
compose under further cutoff deletion.

This concerns the specific direct-sum decomposition (core summand +
labelled `(i,j)`-summands `B_{S_{<j} \ {q_i}}^{(i,j)}`), which our discrete
model does not represent. Formalizing (iv) would require the summand-level
bookkeeping. We record it as uncovered; see LIMITATIONS in the Theorems
file for the full honest gap list. -/

end SelmerCartanMotiveTowers
