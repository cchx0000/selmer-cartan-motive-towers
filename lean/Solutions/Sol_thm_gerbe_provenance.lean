import Definitions.Def_adic_witness
import Definitions.Def_witness_background
import Definitions.Def_gerbe_provenance

namespace SelmerCartanMotiveTowers

/-- Solution for Theorem 38.1 (`thm_gerbe_provenance`), M15.

The witness background package's §4 fields record the paper's gerbe
provenance data (31-adic arithmetic + the Dwyer defining-system theorem in
LLSWW form): the gerbe `bg.gerbe`, its `μ_{31}`-gerbe property
`bg.gerbeIs`, and the universal provenance clause `bg.gerbeProvenance`
for every 31-adic witness.

REVISION NOTE (P1-4 M15, 2026-10-10, narrowed): The conclusion now also
provides the concrete operation-level provenance `bg.gerbeProvenanceData :
GerbeProvenance` — the classifying map with its `x^{(30)}, λ_*` coordinate
profile, the pointed pullback identity `ρ̄^* ω_{31}^{univ} = κ_5^{root} =
c_1^{(31)}(Q_5)`, and the unipotent central extension with order-31 kernel.
This SITS ALONGSIDE, rather than replaces, the bare `provenanceFor`
predicate: the conclusion still projects `bg.provenanceFor G W` as a
conjunct. The `GerbeProvenance` data is projected from
`bg.gerbeProvenanceData` (a background field), and the full
algebraic-stack construction remains background (CITED).

REVISION NOTE (P1-5 M15, 2026-10-11): the `GerbeProvenance` interface is
strengthened and the conclusion consumes the new structure —
* the classifying map is bound to its coordinate profile (`map_coords`);
* the pullback identity carries the genuine pullback operation with the
  square equation, and the conclusion projects the composed identity
  `pullbackOp univClass = c_1^{(31)}(Q_5)`;
* the unipotent extension `U → Ū` (paper L15805–15820) now has group
  structures on both sides, `proj` a surjective homomorphism, band action
  laws, and the conclusion projects the two-sided kernel identification
  `proj t = 0 ↔ ∃ n : ZMod 31, t = n • kernelGen`;
* the conclusion projects the cartesian classifying/pullback square's
  commutativity (paper L15832–15873);
* the old `base_eq` (bare type equality of extension base with classifying
  source) is replaced by `quotIdentification`, an explicitly assumed
  identification map — the geometric `X_*` is not required to be a group.
`provenanceFor` is RETAINED as an unbound background predicate (not
deleted, not tied to the concrete data). The gerbe projection
`G_{f_*} → X_*` (L15852–15864) remains a separate unformalized geometric
structure, distinct from the group-scheme extension `U → Ū`. -/
theorem sol_thm_gerbe_provenance (W : adic_witness) (bg : WitnessBackground) :
    ∃ G : bg.Gerbe, bg.isMu31Gerbe G ∧ bg.provenanceFor G W ∧
      ∃ P : GerbeProvenance, P = bg.gerbeProvenanceData ∧
        addOrderOf P.extension.kernelGen = 31 ∧
        P.pullback.pullbackOp P.pullback.univClass = P.pullback.c1_31_Q5 ∧
        (∀ t : P.extension.total, P.extension.proj t = 0 ↔
          ∃ n : ZMod 31, t = n • P.extension.kernelGen) ∧
        ∀ g : P.square.gerbe,
          P.square.inducedMap (P.square.gerbeToTotal g) =
            P.classifying.map (P.square.gerbeToSource g) :=
  ⟨bg.gerbe, bg.gerbeIs, bg.gerbeProvenance W, bg.gerbeProvenanceData, rfl,
    bg.gerbeProvenanceData.extension.kernelOrder,
    bg.gerbeProvenanceData.pullback.square_eq_chern,
    fun t => bg.gerbeProvenanceData.extension.kernelMem_iff t,
    fun g => bg.gerbeProvenanceData.square.square_comm g⟩

end SelmerCartanMotiveTowers
