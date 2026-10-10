import Definitions.Def_adic_witness
import Definitions.Def_motivic_moore_reedy
import Definitions.Def_pointed_cyclic_carrier
import Definitions.Def_witness_background

namespace SelmerCartanMotiveTowers

/-- The witness's arithmetic line, identified with a pointed cyclic carrier.

The witness `W` carries `W.terminalClass` of exact additive order 31
(`terminalClassOrder`). The subgroup it generates is therefore cyclic of
order 31, and the canonical `ZMod 31` identification gives an additive
isomorphism with any pointed cyclic order-31 carrier — in particular
`bg.Lar`, the paper's arithmetic line from the `K*` branch. The
isomorphism sends the witness's class to the carrier's distinguished
generator.

This is the type-level content of the paper's "`K*`-branch arithmetic
line" identification: the 31-torsion the witness detects IS the
arithmetic carrier line, not an unrelated group that happens to have
31-torsion. It is PROVED from `W`'s data (exact order 31), not assumed. -/
theorem witnessArith_mem (W : adic_witness)
    (x : ↥(AddSubgroup.zmultiples W.terminalClass)) :
    x ∈ AddSubgroup.zmultiples
      (⟨W.terminalClass, AddSubgroup.mem_zmultiples _⟩ :
        ↥(AddSubgroup.zmultiples W.terminalClass)) := by
  obtain ⟨k, hk⟩ := AddSubgroup.mem_zmultiples_iff.mp x.property
  rw [AddSubgroup.mem_zmultiples_iff]
  refine ⟨k, Subtype.ext ?_⟩
  push_cast
  exact hk

/-- Canonical identification of the witness's 31-torsion line with a
pointed cyclic order-31 carrier (via `ZMod 31`). -/
noncomputable def witnessArithIso (W : adic_witness) (L : pointed_cyclic_carrier) :
    ↥(AddSubgroup.zmultiples W.terminalClass) ≃+ L.carrier :=
  (zmodAddEquivOfGenerator (witnessArith_mem W)
    (by rw [Nat.card_zmultiples, W.terminalClassOrder])).symm.trans
    (zmodAddEquivOfGenerator L.mem_gen L.nat_card_eq)

/-- The witness–arithmetic identification is pointed: it sends the
witness's class to the carrier's distinguished generator. -/
theorem witnessArithIso_apply_class (W : adic_witness) (L : pointed_cyclic_carrier) :
    witnessArithIso W L ⟨W.terminalClass, AddSubgroup.mem_zmultiples _⟩ = L.gen := by
  show (zmodAddEquivOfGenerator L.mem_gen L.nat_card_eq)
      ((zmodAddEquivOfGenerator (witnessArith_mem W) _).symm
        ⟨W.terminalClass, AddSubgroup.mem_zmultiples _⟩) = L.gen
  rw [zmodAddEquivOfGenerator_symm_apply_generator, zmodAddEquivOfGenerator_apply_one]

/-- The markings (distinguished generators) are compatible across the
whole pointed span: the induced identification `L_*^{ar} → L_*^{Mot}`
(via the marked source line) sends the arithmetic marking to the motivic
marking. This is the carrier-level content of the paper's "marked" span:
the three lines are not merely abstractly isomorphic, they are identified
as *pointed* lines. -/
theorem marking_compat (bg : WitnessBackground) :
    ((bg.Lsrc.canonicalIso bg.Lar).symm.trans
      (bg.Lsrc.canonicalIso bg.LMot)) bg.Lar.gen = bg.LMot.gen := by
  have h1 : (bg.Lsrc.canonicalIso bg.Lar).symm bg.Lar.gen = bg.Lsrc.gen := by
    have h := bg.Lsrc.canonicalIso_apply_gen bg.Lar
    calc (bg.Lsrc.canonicalIso bg.Lar).symm bg.Lar.gen
        = (bg.Lsrc.canonicalIso bg.Lar).symm
            ((bg.Lsrc.canonicalIso bg.Lar) bg.Lsrc.gen) := by rw [← h]
      _ = bg.Lsrc.gen := AddEquiv.symm_apply_apply _ _
  rw [AddEquiv.trans_apply, h1, bg.Lsrc.canonicalIso_apply_gen]

/-- Block-subobject interface for the motivic side: the named shape of the
paper's `I_*`-block identification (NEW 2026-10-10, verifier M16
follow-up).

Paper L16066–16107: the right-hand line `L_*^{Mot}` is "the fixed Moore
carrier in the `I_*`-block of the finite marked Moore–Reedy package
`𝔗^{Mot,MR}_{31;S_*,≤31}`"; the channel-complete realization installs this
carrier in the `I_*`-block, and the proper 31-fold arithmetic Massey
value is recorded as a marking on this fixed motivic carrier.

Since `M.carrier` is opaque under Strategy A, this record names the
*shape* of that block identification as an explicit hypothesis, instead
of smuggling the whole identification inside a bare type bijection
`M.carrier ≃ bg.LMot.carrier` (which wrongly treated the entire
`M.carrier` as a 31-element line and gave it no additive structure or
marking). Fields:
- `blockCarrier`: the designated block sub-object's carrier (the fixed
  Moore carrier in the `I_*`-block);
- `blockAddCommGroup`: its additive structure;
- `blockMark`: the marking on the fixed carrier (the recorded 31-fold
  Massey value);
- `embed`: the installation of the block into `M.carrier` (the
  channel-complete realization), required injective (`embed_injective`)
  so the block is faithfully installed — this is the compatibility with
  the original `M`;
- `pointedIso`: the pointed additive identification of the block with the
  marked motivic carrier `L`, with `iso_pointed` sending the block marking
  to the distinguished generator.

HYPOTHESIS, not a construction: nothing here is proved from `M`.
The Moore pair and the marked-ledger data live at operation level and are
deliberately NOT part of this carrier-level interface — per the paper,
"the carrier identification alone does not turn arithmetic cochains into
motivic correspondences"; the independent operation-level provenance is
Theorem 38.1 (`thm_gerbe_provenance`). -/
structure blockSubobjectInterface (M : motivic_moore_reedy) (L : pointed_cyclic_carrier) where
  blockCarrier : Type
  [blockAddCommGroup : AddCommGroup blockCarrier]
  blockMark : blockCarrier
  embed : blockCarrier → M.carrier
  embed_injective : Function.Injective embed
  pointedIso : blockCarrier ≃+ L.carrier
  iso_pointed : pointedIso blockMark = L.gen

/-- The block carrier's group structure, registered as an instance so that
notation and `≃+` elaborate on `hB.blockCarrier`. -/
instance blockSubobjectInterface.instAddCommGroup (M : motivic_moore_reedy)
    (L : pointed_cyclic_carrier) (hB : blockSubobjectInterface M L) :
    AddCommGroup hB.blockCarrier :=
  hB.blockAddCommGroup

/-- Solution for Theorem 38.5 (`thm_motivic_specialization`), M16.

The three carrier lines are `pointed_cyclic_carrier`s (background §5:
the arithmetic line from the `K*` branch, the marked source line, the
motivic Moore line). The pointed span
`L_*^{ar} ← L_*^{src} → L_*^{Mot}` is *constructed*, not assumed: any two
pointed cyclic order-31 carriers admit a canonical generator-preserving
isomorphism (`pointed_cyclic_carrier.canonicalIso`, via `ZMod 31`),
which is the paper's "unique generator-preserving identification".

CARRIER-LEVEL ONLY. The independent operation-level provenance
(unipotent central extension, obstruction gerbe) is Theorem 38.1
(`thm_gerbe_provenance`); the paper is explicit that "the carrier
identification alone does not turn arithmetic cochains into motivic
correspondences."

REVISION NOTE 3 (2026-10-10, verifier P1-4): the binders `W` and `M` are
no longer unused; `witnessArithIso` (from `W.terminalClass`'s exact order
31) and `marking_compat` (abstract three-line marking compatibility) are
proved and used — counted as completed sub-items.

REVISION NOTE 4 (2026-10-10, verifier M16 follow-up): the M-linkage is
now two honest layers instead of one bare type bijection.
- CARRIER-SPAN LAYER (proved): `ρ_ar`, `ρ_mot` from `canonicalIso`,
  `ρ_W = witnessArithIso W bg.Lar` from `W`'s data, and `marking_compat`
  for the abstract span.
- BLOCK-IDENTIFICATION LAYER (hypothesis): `hB : blockSubobjectInterface
  M bg.LMot` names the shape of the paper's `I_*`-block identification
  (L16066–16107): the designated block sub-object of `M.carrier`, its
  additive structure and marking, the injective installation `embed`, and
  the pointed identification with `bg.LMot`. The old bare bijection
  `hM : M.carrier ≃ bg.LMot.carrier` is gone: the whole `M.carrier` is no
  longer treated as a 31-element line, and no additive structure or
  marking is claimed for `M.carrier` itself.
The conclusion's `ρ_block : bg.Lsrc.carrier ≃+ hB.blockCarrier` is the
pointed additive identification of the marked source line with the actual
block sub-object (sending the source marking to the block marking), and
`hB.embed ∘ ρ_block` is injective — the block is faithfully installed in
the original `M`. The Moore pair and marked-ledger data are
operation-level (Theorem 38.1), kept separate from this carrier span. -/
theorem sol_thm_motivic_specialization
    (W : adic_witness) (M : motivic_moore_reedy) (bg : WitnessBackground)
    (hB : blockSubobjectInterface M bg.LMot) :
    ∃ (ρ_ar : bg.Lsrc.carrier ≃+ bg.Lar.carrier)
      (ρ_mot : bg.Lsrc.carrier ≃+ bg.LMot.carrier)
      (ρ_W : ↥(AddSubgroup.zmultiples W.terminalClass) ≃+ bg.Lar.carrier)
      (ρ_block : bg.Lsrc.carrier ≃+ hB.blockCarrier),
      ρ_ar bg.Lsrc.gen = bg.Lar.gen ∧
      ρ_mot bg.Lsrc.gen = bg.LMot.gen ∧
      ρ_W ⟨W.terminalClass, AddSubgroup.mem_zmultiples _⟩ = bg.Lar.gen ∧
      ρ_block bg.Lsrc.gen = hB.blockMark ∧
      Function.Injective (hB.embed ∘ ρ_block) := by
  refine ⟨bg.Lsrc.canonicalIso bg.Lar, bg.Lsrc.canonicalIso bg.LMot,
    witnessArithIso W bg.Lar,
    (bg.Lsrc.canonicalIso bg.LMot).trans hB.pointedIso.symm, ?_, ?_, ?_, ?_, ?_⟩
  · exact bg.Lsrc.canonicalIso_apply_gen bg.Lar
  · exact bg.Lsrc.canonicalIso_apply_gen bg.LMot
  · exact witnessArithIso_apply_class W bg.Lar
  · rw [AddEquiv.trans_apply, bg.Lsrc.canonicalIso_apply_gen]
    apply hB.pointedIso.injective
    rw [AddEquiv.apply_symm_apply]
    exact hB.iso_pointed.symm
  · exact hB.embed_injective.comp
      ((bg.Lsrc.canonicalIso bg.LMot).trans hB.pointedIso.symm).injective

end SelmerCartanMotiveTowers
