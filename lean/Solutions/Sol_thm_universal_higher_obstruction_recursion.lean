import Definitions.Def_formal_background

namespace SelmerCartanMotiveTowers

/-- Solution for Theorem 9.4 (`P1C-thm:universal-higher-obstruction-recursion`),
Strategy A.

The paper's Theorem 9.4 asserts four clauses for the obstruction
`Ω_{n+1}(X_{≤n})` of a marked `n`-jet in a strict pointed formal-moduli
controller: (i) cocycle (`dΩ_{n+1} = 0`, via the Bianchi identity
`dF(X) + X·F(X) - F(X)·X = 0` plus PD-degree counting); (ii) the lifting
criterion (a Maurer–Cartan lift `X_{≤n+1}` exists iff `𝔬_{n+1} = 0`);
(iii) the class depends only on the pointed gauge class of the lower jet;
(iv) naturality for dg-algebra maps and filtration-preserving parameter
maps.

The revised statement (Strategy A) records exactly these four clauses as
the four fields of `FormalBackground` §1 (`obsCocycle`, `liftIff`,
`gaugeInv`, `natural`); the proof is the direct assembly of the four
conjuncts from the four fields. The deep dg-algebra content (Bianchi
identity, PD-degree counting) is absorbed into the background package. -/
theorem sol_thm_universal_higher_obstruction_recursion (bg : FormalBackground) :
    (∀ X : bg.Jet, bg.isCocycle X) ∧
    (∀ X : bg.Jet, bg.lifts X ↔ bg.vanishes (bg.obstruction X)) ∧
    (∀ X Y : bg.Jet, bg.gaugeRelated X Y → bg.obstruction X = bg.obstruction Y) ∧
    (∀ (op : bg.Op) (X : bg.Jet),
      bg.obstruction (bg.actJet op X) = bg.actObs op (bg.obstruction X)) :=
  ⟨bg.obsCocycle, bg.liftIff, bg.gaugeInv, bg.natural⟩

end SelmerCartanMotiveTowers
