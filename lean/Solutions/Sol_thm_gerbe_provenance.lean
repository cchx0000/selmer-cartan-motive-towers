import Definitions.Def_adic_witness
import Definitions.Def_witness_background

namespace SelmerCartanMotiveTowers

/-- Solution for Theorem 38.1 (`thm_gerbe_provenance`), M15.

The witness background package's §4 fields record the paper's gerbe
provenance data (31-adic arithmetic + the Dwyer defining-system theorem in
LLSWW form): the gerbe `bg.gerbe`, its `μ_{31}`-gerbe property
`bg.gerbeIs`, and the universal provenance clause `bg.gerbeProvenance`
for every 31-adic witness. The proof is direct assembly. -/
theorem solution (W : adic_witness) (bg : WitnessBackground) :
    ∃ G : bg.Gerbe, bg.isMu31Gerbe G ∧ bg.provenanceFor G W :=
  ⟨bg.gerbe, bg.gerbeIs, bg.gerbeProvenance W⟩

end SelmerCartanMotiveTowers
