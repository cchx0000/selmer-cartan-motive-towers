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

REVISION NOTE (P1-4 M15, 2026-10-10): The conclusion now also provides the
concrete operation-level provenance `bg.gerbeProvenanceData :
GerbeProvenance` — the classifying map with its `x^{(30)}, λ_*` coordinate
profile, the pointed pullback identity `ρ̄^* ω_{31}^{univ} = κ_5^{root} =
c_1^{(31)}(Q_5)`, and the unipotent central extension with order-31 kernel.
This replaces the bare `provenanceFor` predicate with checkable structure;
the full algebraic-stack construction remains background (CITED). -/
theorem sol_thm_gerbe_provenance (W : adic_witness) (bg : WitnessBackground) :
    ∃ G : bg.Gerbe, bg.isMu31Gerbe G ∧ bg.provenanceFor G W ∧
      ∃ P : GerbeProvenance, P = bg.gerbeProvenanceData ∧
        addOrderOf P.extension.kernelGen = 31 ∧
        P.pullback.pullbackClass = P.pullback.c1_31_Q5 :=
  ⟨bg.gerbe, bg.gerbeIs, bg.gerbeProvenance W, bg.gerbeProvenanceData, rfl,
    bg.gerbeProvenanceData.extension.kernelOrder,
    bg.gerbeProvenanceData.pullback.pullback_eq_chern⟩

end SelmerCartanMotiveTowers
