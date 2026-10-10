import Definitions.Def_typed_coordinates
import Definitions.Def_source_package
import Mathlib.Data.ZMod.Basic
import Mathlib.Algebra.Group.Finsupp

namespace SelmerCartanMotiveTowers

/-! # Real confluent package data (P1-2 deep revision, 2026-10-09)

Paper reference: `P1C-def:pd-direction-hull` (L2289), support deletion /
permutation (L2415–2427), coefficient ring `R_ν = ℤ/N_ν` (L4236), and the
finite package `I^{Conf}_{S,m,ν}` (L5147–5168).

We formalize:
- `D_S = ⊕_{i∈S} ℤ e_i` as `S.primes →₀ ℤ` (the REAL marked direction
  lattice, not `(S.primes → ℤ) × ℤ`);
- `R_ν = ZMod N_ν` with `N_ν = ∏ p^{ν_p}` (the REAL coefficient ring,
  not `ℤ`);
- support deletion `π_T` as a real coordinate projection (idempotent
  because it is a projection, not constant zero);
- permutation action via `Finsupp.domCongr` on equivalences (real linear
  maps, not arbitrary functions), with identity and composition laws;
- deletion–permutation naturality.

LIMITATION (PD hull): the full divided-power algebra `Γ^m(D_S)` is not
constructed (Mathlib's `DividedPowers` covers DP structures on ideals,
not the free PD algebra). What we formalize is the *functorial action
package* — deletion, relabelling, direction-linear maps — which the
paper shows acts through `Γ^m` (L2374, L2427). The `gammaMult`
scalar action below is the direction lattice equipped with this action
package; the divided-power multiplication itself remains background.
-/

/-- The marked direction lattice `D_S = ⊕_{i∈S} ℤ e_i`
(paper `P1C-def:pd-direction-hull`). -/
abbrev direction_lattice (S : finite_ordered_support) := ↥S.primes →₀ ℤ

/-- Basis vector `e_i`. -/
noncomputable def dirBasis (S : finite_ordered_support) (i : ↥S.primes) :
    direction_lattice S :=
  Finsupp.single i 1

/-- Coefficient modulus `N_ν = ∏ p^{ν_p}` (paper L4236). -/
def coeffModulus (ν : coefficient_exponent) : ℕ :=
  ν.val.prod fun p e => p.val ^ e

/-- Coefficient ring `R_ν = ℤ/N_ν` (paper L4236). -/
abbrev coeff_ring (ν : coefficient_exponent) := ZMod (coeffModulus ν)

/-- Support deletion `π_T : D_S → D_S`: `e_i ↦ e_i` if `i ∈ T`, else `0`
(paper L2415–2423). A real projection, hence idempotent. -/
def supportDelete (S : finite_ordered_support) (T : Finset ↥S.primes) :
    direction_lattice S →+ direction_lattice S where
  toFun f := f.filter (fun i => i ∈ T)
  map_zero' := Finsupp.filter_zero _
  map_add' := by
    intro x y
    ext i
    by_cases h : i ∈ T <;> simp [Finsupp.filter_apply, h]

/-- Deletion is idempotent (projection). -/
theorem supportDelete_idem (S : finite_ordered_support) (T : Finset ↥S.primes)
    (x : direction_lattice S) :
    supportDelete S T (supportDelete S T x) = supportDelete S T x := by
  ext i
  simp [supportDelete, Finsupp.filter_apply]
  by_cases h : i ∈ T <;> simp [h]

/-- Permutation action: `σ : S ≃ S` induces `D_S ≃+ D_S`
(paper L2427: `e_i ↦ e_{σ(i)}`). -/
def permActDir (S : finite_ordered_support) (σ : ↥S.primes ≃ ↥S.primes) :
    direction_lattice S ≃+ direction_lattice S :=
  Finsupp.domCongr σ

/-- Permutation action identity law. -/
theorem permActDir_id (S : finite_ordered_support) :
    permActDir S (Equiv.refl _) = AddEquiv.refl _ :=
  Finsupp.domCongr_refl

/-- Permutation action composition law (contravariant in `∘`:
`σ.trans τ` is `τ ∘ σ` as a function). -/
theorem permActDir_comp (S : finite_ordered_support)
    (σ τ : ↥S.primes ≃ ↥S.primes) :
    permActDir S (σ.trans τ) = (permActDir S σ).trans (permActDir S τ) := by
  apply AddEquiv.ext
  intro x
  have := Finsupp.equivMapDomain_trans σ τ x
  simpa [permActDir] using this

/-- Deletion–permutation naturality: deleting `T` then permuting by `σ`
equals permuting by `σ` then deleting the permuted set `σ '' T`. -/
theorem delete_perm_natural (S : finite_ordered_support)
    (σ : ↥S.primes ≃ ↥S.primes) (T : Finset ↥S.primes)
    (x : direction_lattice S) :
    permActDir S σ (supportDelete S T x)
      = supportDelete S (T.map σ.toEmbedding) (permActDir S σ x) := by
  ext i
  simp only [supportDelete, permActDir, AddMonoidHom.coe_mk, ZeroHom.coe_mk,
    Finsupp.domCongr_apply, Finsupp.filter_apply]
  by_cases h : σ.symm i ∈ T
  · have h2 : i ∈ T.map σ.toEmbedding := by
      rw [Finset.mem_map]
      exact ⟨σ.symm i, h, by simp⟩
    simp [h, h2]
  · have h2 : i ∉ T.map σ.toEmbedding := by
      rw [Finset.mem_map]
      rintro ⟨j, hj, heq⟩
      apply h
      have hji : σ j = i := by
        have := congrArg Subtype.val heq
        simpa using this
      have hjeq : j = σ.symm i := by
        have := congrArg σ.symm hji
        simpa using this
      rw [hjeq] at hj
      exact hj
    simp [h, h2]

/-- The direction lattice is nontrivial iff the support is nonempty.
Empty support is a legal degenerate case (then `D_S = 0`). -/
theorem dirLat_nontrivial_iff (S : finite_ordered_support) :
    Nontrivial (direction_lattice S) ↔ S.primes.Nonempty := by
  rw [Finsupp.nontrivial_iff]
  constructor
  · intro ⟨h, _⟩
    obtain ⟨x⟩ := h
    exact ⟨x.val, x.property⟩
  · intro h
    obtain ⟨x, hx⟩ := h
    exact ⟨⟨⟨x, hx⟩⟩, inferInstance⟩

/-! ## Multiplicity-`m` action `Γᵐ` (P1-2 M4 deep, 2026-10-10)

Paper L5147–5168: the package is `(D_S, Γ^m(D_S), R_ν, Conf(m), D_m,
Res, W^{PD}_{N_ν;S,m})`. "Support deletion, relabelling, and
direction-linear maps act through `Γ^m`" (L2374, L2427).

We formalize the multiplicity-`m` scalar action on the direction
lattice as a *model* of the paper's `Γᵐ`-action: the real divided-power
action is NOT formalized — `gammaMult S m v = m • v` is scalar
multiplication only. This is the action-level shadow of the
divided-power algebra; the divided-power multiplication itself remains
background (see LIMITATION above).
-/

/-- Multiplicity-`m` scalar action: the scalar-multiplication *model* of the
paper's `Γᵐ`-action on `D_S` (`gammaMult S m v = m • v`). The genuine
divided-power action is not formalized; see LIMITATION (PD hull) above.
Paper: direction-linear maps act through `Γ^m`. -/
noncomputable def gammaMult (S : finite_ordered_support) (m : ℕ) :
    direction_lattice S →+ direction_lattice S where
  toFun v := m • v
  map_zero' := smul_zero m
  map_add' x y := smul_add m x y

/-- `Γ^0` is the zero map. -/
theorem gammaMult_zero (S : finite_ordered_support) (v : direction_lattice S) :
    gammaMult S 0 v = 0 := by
  simp [gammaMult]

/-- `Γ^{m+n} = Γ^m + Γ^n` (additivity in the multiplicity index). -/
theorem gammaMult_add (S : finite_ordered_support) (m n : ℕ)
    (v : direction_lattice S) :
    gammaMult S (m + n) v = gammaMult S m v + gammaMult S n v := by
  simp [gammaMult, add_smul]

/-! ## Confluence coarsening (P1-2 M4 deep, 2026-10-10)

Paper L5147–5168: "confluence coarsenings act through the scalar `M(f)`,
the torsion-defect functor `D_m`, and the resonance divisor `Res(f)`".

We formalize the support-level coarsening action: coarsening by `T`
deletes the coordinates in `T` (dually to `supportDelete`, which keeps
`T`). The scalar `M(f)` (with `M(g∘f) = M(g)M(f)`, L3694–3714) and the
resonance divisor `Res(f)` (with `Res(g∘f) = Res(f) + Res(g)`, L3783)
are recorded as background; what we formalize is the coarsening action
on the carrier with its composition law.
LIMITATION: this is the *coordinate-deletion model* of coarsening only;
the scalar `M(f)` / torsion-defect / resonance-divisor content of the
paper's coarsening is not formalized.
-/

/-- Confluence coarsening: delete the coordinates in `T`.
This is `supportDelete` of the complement. -/
def coarsen (S : finite_ordered_support) (T : Finset ↥S.primes) :
    direction_lattice S →+ direction_lattice S :=
  supportDelete S (Finset.univ \ T)

/-- Deletion composes by intersection (used for the coarsening law). -/
theorem supportDelete_comp (S : finite_ordered_support)
    (A B : Finset ↥S.primes) :
    (supportDelete S A).comp (supportDelete S B)
      = supportDelete S (A ∩ B) := by
  apply AddMonoidHom.ext
  intro x
  ext i
  simp only [supportDelete, AddMonoidHom.comp_apply, AddMonoidHom.coe_mk,
    ZeroHom.coe_mk, Finsupp.filter_apply]
  by_cases hA : i ∈ A <;> by_cases hB : i ∈ B <;> simp [hA, hB]

/-- Coarsening by the empty set is the identity. -/
theorem coarsen_empty (S : finite_ordered_support) :
    coarsen S ∅ = AddMonoidHom.id _ := by
  apply AddMonoidHom.ext
  intro x
  ext i
  simp [coarsen, supportDelete, Finsupp.filter_apply]

/-- Coarsening composes over unions:
`coarsen (T₁ ∪ T₂) = coarsen T₁ ∘ coarsen T₂`. -/
theorem coarsen_union (S : finite_ordered_support)
    (T₁ T₂ : Finset ↥S.primes) :
    coarsen S (T₁ ∪ T₂) = (coarsen S T₁).comp (coarsen S T₂) := by
  simp only [coarsen, supportDelete_comp]
  congr 1
  ext i
  simp only [Finset.mem_sdiff, Finset.mem_inter, Finset.mem_union, not_or]
  tauto

/-! ## Cross-support package maps (P1-2 M4 deep, 2026-10-10)

Paper L5147–5168: "The higher-support coherence ledger extends this
package without changing its finite carrier type."

For `S₁.primes ⊆ S₂.primes`, we define the zero-extension
`D_{S₁} → D_{S₂}` via `supportInclusion`/`extendSupport`.
LIMITATION: naturality of `extendSupport` with `supportDelete`
(`supportDelete S₂ T (extendSupport v) = extendSupport (supportDelete S₁ T v)`)
is not proved — the `Finsupp.embDomain` range API is unstable in this
Mathlib version; see LIMITATIONS section below.
-/

/-- Inclusion of supports as an embedding. -/
def supportInclusion (S₁ S₂ : finite_ordered_support)
    (h : S₁.primes ⊆ S₂.primes) : ↥S₁.primes ↪ ↥S₂.primes where
  toFun i := ⟨i.val, h i.property⟩
  inj' a b hab := by
    simp only [Subtype.mk.injEq] at hab
    exact Subtype.ext hab

/-- Cross-support package map: zero-extension `D_{S₁} → D_{S₂}`. -/
noncomputable def extendSupport (S₁ S₂ : finite_ordered_support)
    (h : S₁.primes ⊆ S₂.primes) :
    direction_lattice S₁ →+ direction_lattice S₂ where
  toFun v := v.embDomain (supportInclusion S₁ S₂ h)
  map_zero' := Finsupp.embDomain_zero _
  map_add' x y := Finsupp.embDomain_add _ _ _

/- NOTE: Compatibility of `extendSupport` with `gammaMult` and
`supportDelete` (naturality) is future work; the `embDomain` API for
the required range/smul analysis is not yet stable in this Mathlib
version. The definition above provides the cross-support map whose
existence the paper requires (L5147–5168: "The higher-support coherence
ledger extends this package"). -/

/-! ## LIMITATION: PD structure, torsion defect, resonance divisor

The divided-power algebra `Γ^m(D_S)` itself (not just its scalar
action), the torsion-defect functor `D_m` (paper L4088:
`E_m : Conf(m) → Vect^{(1)}_ℚ`), and the resonance divisor `Res`
(L3741, L3783: `Res(g∘f) = Res(f) + Res(g)`) are not constructed.
Mathlib's `DividedPowers` covers DP structures on ideals, not the free
PD algebra on a module. The category `Conf(m)` of multiplicity profiles
(L3694) is also not formalized. What we provide above — the
multiplicity-indexed scalar action `gammaMult`, the support coarsening
`coarsen` with composition law, and the cross-support `extendSupport`
(whose deletion naturality is future work, see NOTE above) — is the
functorial action package that the paper shows acts through `Γ^m`.
-/

end SelmerCartanMotiveTowers
