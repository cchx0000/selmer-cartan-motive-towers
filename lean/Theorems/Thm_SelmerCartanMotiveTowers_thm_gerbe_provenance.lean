import Definitions.Def_adic_witness
import Definitions.Def_witness_background
import Definitions.Def_gerbe_provenance
import Solutions.Sol_thm_gerbe_provenance

namespace SelmerCartanMotiveTowers

/-- Terminal proper-31-fold unipotent-gerbe provenance (Theorem 38.1,
`W31-thm:terminal-unipotent-gerbe-provenance`), REVISED per Strategy A.

Assuming the witness arithmetic background (`WitnessBackground` §3–4: the
31-adic data — LLSWW specialization identifying the proper 31-fold Massey
value with `κ₅^root`, the Kummer identification — plus the Dwyer
defining-system theorem [DwyerMassey, CITED] in its LLSWW generalized form),
the proper defining system `ρ_{f*}` assembles into a classifying morphism
whose universal obstruction satisfies the pointed identity
`ρ̄_{f*}^* ω_{31}^{univ} = (x^{(30)}, λ_*) = κ₅^{root} = c₁^{(31)}(Q₅)`; the
homotopy pullback is an algebraic `μ_{31}`-gerbe, an independent
algebraic-stack correspondence provenance for the terminal proper-31-fold
operation law attached to the 31-adic witness.

The conclusion provides the concrete `GerbeProvenance` package: the
classifying map's 31-coordinate profile (bound to the morphism), the
pullback identity with its genuine pullback operation and square equation,
the unipotent central extension `U → Ū` (paper L15805–15820) with
surjective-homomorphism projection, band action laws, and two-sided kernel
identification, and the cartesian classifying/pullback square
(L15832–15873). The gerbe projection `G_{f_*} → X_*` (L15852–15864) is a
separate geometric structure, not formalized here; the geometric `X_*` is
not required to be a group.

REVISION NOTE (2026-10-09): The first draft was FALSE — it universally
quantified over an arbitrary `Gerbe` type and unconstrained
`isMu31Gerbe`/`provenanceFor` predicates while the conclusion required them
to hold (countermodel: both constantly `False`). This revision takes the
paper's specific gerbe data (from the 31-adic arithmetic + Dwyer) as an
explicit hypothesis.

REVISION NOTE (P1-4 M15, 2026-10-10): Added the concrete `GerbeProvenance`
conjunct — classifying map, pullback identity, unipotent extension — so the
"arbitrary predicate" criticism no longer applies.

REVISION NOTE (P1-5 M15, 2026-10-11): strengthened per the verifier's M15
audit — direction unified to the paper's exact sequence `U → Ū`;
`UnipotentExtension` gains group structures, a surjective-homomorphism
`proj`, band action laws, and a derived two-sided kernel identification
(consumed as a conjunct); `PullbackIdentity` gains the genuine pullback
operation and square equation (the composed `pullbackOp univClass =
c_1^{(31)}(Q_5)` is a conjunct); the cartesian square's commutativity is a
conjunct; `base_eq` is narrowed to the assumed identification map
`quotIdentification`; `provenanceFor` is retained as an unbound predicate. -/
theorem thm_gerbe_provenance (W : adic_witness) (bg : WitnessBackground) :
    ∃ G : bg.Gerbe, bg.isMu31Gerbe G ∧ bg.provenanceFor G W ∧
      ∃ P : GerbeProvenance, P = bg.gerbeProvenanceData ∧
        addOrderOf P.extension.kernelGen = 31 ∧
        P.pullback.pullbackOp P.pullback.univClass = P.pullback.c1_31_Q5 ∧
        (∀ t : P.extension.total, P.extension.proj t = 0 ↔
          ∃ n : ZMod 31, t = n • P.extension.kernelGen) ∧
        ∀ g : P.square.gerbe,
          P.square.inducedMap (P.square.gerbeToTotal g) =
            P.classifying.map (P.square.gerbeToSource g) :=
  SelmerCartanMotiveTowers.sol_thm_gerbe_provenance W bg

end SelmerCartanMotiveTowers
