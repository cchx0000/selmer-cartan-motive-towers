import Mathlib.Algebra.Group.Nat.Defs
import Mathlib.Data.Fintype.Card
import Mathlib.GroupTheory.SpecificGroups.Cyclic

namespace SelmerCartanMotiveTowers

/-- Formal/filtered alignment at depth two (Theorem 8.21,
`P1C-thm:formal-filtered-alignment`): the universal exact-order Moore line
and the primitive filtered confluence line — both cyclic of exact order
`p·q²` with fixed primitive generators — admit a unique pointed
isomorphism sending generator to generator. Under `q`-primary reduction it
sends the universal Moore generator to the residual secondary generator. -/
theorem solution
    (p q : Nat) (hp : p.Prime) (hq : q.Prime)
    (MooreLine ConfLine : Type) [AddCommGroup MooreLine] [AddCommGroup ConfLine]
    [Fintype MooreLine] [Fintype ConfLine]
    (hcardM : Fintype.card MooreLine = p * q ^ 2)
    (hcardC : Fintype.card ConfLine = p * q ^ 2)
    (b : MooreLine) (hb : ∀ x : MooreLine, ∃ k : Nat, x = k • b)
    (c : ConfLine) (hc : ∀ y : ConfLine, ∃ k : Nat, y = k • c)
    : ∃! Φ : MooreLine →+ ConfLine, Φ b = c := by
  -- Every element is an *integer* multiple of the generator.
  have hgM : ∀ x : MooreLine, x ∈ AddSubgroup.zmultiples b := by
    intro x
    obtain ⟨k, hk⟩ := hb x
    rw [AddSubgroup.mem_zmultiples_iff]
    exact ⟨(k : ℤ), by exact_mod_cast hk.symm⟩
  have hgC : ∀ y : ConfLine, y ∈ AddSubgroup.zmultiples c := by
    intro y
    obtain ⟨k, hk⟩ := hc y
    rw [AddSubgroup.mem_zmultiples_iff]
    exact ⟨(k : ℤ), by exact_mod_cast hk.symm⟩
  have hnM : Nat.card MooreLine = p * q ^ 2 := by
    rw [Nat.card_eq_fintype_card, hcardM]
  have hnC : Nat.card ConfLine = p * q ^ 2 := by
    rw [Nat.card_eq_fintype_card, hcardC]
  -- Canonical pointed identifications with `ZMod (p * q ^ 2)`.
  have eM1 : (zmodAddEquivOfGenerator hgM hnM).symm b = 1 :=
    zmodAddEquivOfGenerator_symm_apply_generator hgM hnM
  have eC1 : (zmodAddEquivOfGenerator hgC hnC) 1 = c :=
    zmodAddEquivOfGenerator_apply_one hgC hnC
  have hΦ : (((zmodAddEquivOfGenerator hgM hnM).symm.trans
      (zmodAddEquivOfGenerator hgC hnC)).toAddMonoidHom :
      MooreLine →+ ConfLine) b = c := by
    show (zmodAddEquivOfGenerator hgC hnC)
      ((zmodAddEquivOfGenerator hgM hnM).symm b) = c
    rw [eM1, eC1]
  refine ⟨((zmodAddEquivOfGenerator hgM hnM).symm.trans
    (zmodAddEquivOfGenerator hgC hnC)).toAddMonoidHom, hΦ, ?_⟩
  -- Uniqueness: a hom out of a cyclic group is fixed by its value on a generator.
  intro Φ' hΦ'
  apply AddMonoidHom.ext
  intro x
  obtain ⟨k, hk⟩ := hb x
  subst hk
  rw [map_nsmul, map_nsmul, hΦ', hΦ]

end SelmerCartanMotiveTowers
