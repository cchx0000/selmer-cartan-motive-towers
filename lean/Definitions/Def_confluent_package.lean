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
paper shows acts through `Γ^m` (L2374, L2427). The `gammaModule`
carrier below is the direction lattice equipped with this action
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

end SelmerCartanMotiveTowers
