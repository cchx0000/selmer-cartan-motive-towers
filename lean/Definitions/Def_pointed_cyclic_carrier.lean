import Mathlib.GroupTheory.SpecificGroups.Cyclic

namespace SelmerCartanMotiveTowers

/-- A pointed cyclic carrier line of order 31 (paper §38, Theorem 38.5
`W31-thm:common-source-motivic-span`).

A carrier type with additive commutative group structure and a
distinguished generator of exact additive order 31 which generates the
whole carrier. The three instances in the paper are the arithmetic line
`L_*^{ar}` (from the `K*` branch's `κ₅^root` identification), the marked
source line `L_*^{src}`, and the motivic Moore line `L_*^{Mot}` (the
fixed Moore carrier in the `I_*`-block of the finite marked
Moore–Reedy package).

CARRIER-LEVEL ONLY. This records the cyclic carrier lines and their
pointed span. The independent operation-level provenance (the unipotent
central extension and obstruction-gerbe correspondence) is Theorem 38.1
(`thm_gerbe_provenance`), not here. In the paper's words: "The carrier
identification alone does not turn arithmetic cochains into motivic
correspondences." -/
structure pointed_cyclic_carrier where
  carrier : Type
  [addCommGroup : AddCommGroup carrier]
  gen : carrier
  gen_order : addOrderOf gen = 31
  mem_gen : ∀ x, x ∈ AddSubgroup.zmultiples gen

/-- The carrier's own group structure, registered as an instance so that
notation and `≃+` elaborate on `L.carrier`. -/
instance pointed_cyclic_carrier.instAddCommGroup (L : pointed_cyclic_carrier) :
    AddCommGroup L.carrier :=
  L.addCommGroup

/-- A pointed cyclic order-31 carrier has exactly 31 elements. -/
theorem pointed_cyclic_carrier.nat_card_eq (L : pointed_cyclic_carrier) :
    Nat.card L.carrier = 31 := by
  have h1 : Nat.card (AddSubgroup.zmultiples L.gen) = 31 := by
    rw [Nat.card_zmultiples, L.gen_order]
  calc Nat.card L.carrier
      = Nat.card (AddSubgroup.zmultiples L.gen) :=
        Nat.card_congr (Equiv.subtypeUnivEquiv L.mem_gen).symm
    _ = 31 := h1

/-- Canonical generator-preserving isomorphism between any two pointed
cyclic order-31 carriers, via `ZMod 31`. Paper §38: the "unique
generator-preserving identification". -/
noncomputable def pointed_cyclic_carrier.canonicalIso
    (L1 L2 : pointed_cyclic_carrier) : L1.carrier ≃+ L2.carrier :=
  (zmodAddEquivOfGenerator L1.mem_gen L1.nat_card_eq).symm.trans
    (zmodAddEquivOfGenerator L2.mem_gen L2.nat_card_eq)

/-- The canonical iso sends generator to generator (it is pointed). -/
theorem pointed_cyclic_carrier.canonicalIso_apply_gen
    (L1 L2 : pointed_cyclic_carrier) :
    L1.canonicalIso L2 L1.gen = L2.gen := by
  show (zmodAddEquivOfGenerator L2.mem_gen L2.nat_card_eq)
      ((zmodAddEquivOfGenerator L1.mem_gen L1.nat_card_eq).symm L1.gen)
    = L2.gen
  rw [zmodAddEquivOfGenerator_symm_apply_generator,
    zmodAddEquivOfGenerator_apply_one]

end SelmerCartanMotiveTowers
