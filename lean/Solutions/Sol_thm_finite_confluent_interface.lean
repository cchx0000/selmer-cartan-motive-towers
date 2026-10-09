import Definitions.Def_source_package

namespace SelmerCartanMotiveTowers

/-- Solution for Theorem 11.6 (`thm_finite_confluent_interface`), M4.

The paper (`P1C-thm:finite-confluent-interface`) packages the finite
confluent constructions into `I^{Conf}_{S,m,ν}` with real action structure.
We model the direction lattice `D_S` and the `Γ^m`-module as
`(S.primes → ℤ) × ℤ` (always nontrivial via the `ℤ` factor), the
coefficient ring as `ℤ`, and the remaining carriers as inhabited product
types. The actions are:
- `del`: constant zero map (deletion to empty support), idempotent;
- `permAct σ`: relabelling by precomposition, contravariantly functorial
  (`permAct (τ ∘ σ) = permAct σ ∘ permAct τ` by `Function.comp_assoc`);
- `linAct`: identity functor on endomorphisms, functorial by `rfl`.

REVISION NOTE (P1-2, 2026-10-09): The first proof used `Empty` for all
seven carriers. The strengthened statement requires `Nontrivial`/`Nonempty`
carriers plus the three action maps with composition laws; the new proof
supplies real inhabited types and verifies each law. The deep
`Γ^m`-divided-power construction itself is not formalized (background).
-/
theorem sol_thm_finite_confluent_interface
    (S : finite_ordered_support) (m : confluence_multiplicity)
    (ν : coefficient_exponent) :
    ∃ (P : source_package)
      (del : P.baseDatum → P.baseDatum)
      (permAct : (S.primes → S.primes) → P.baseDatum → P.baseDatum)
      (linAct : (P.baseDatum → P.baseDatum) → P.gammaModule → P.gammaModule),
      P.support = S ∧ P.confluenceMult = m ∧ P.coeffExponent = ν ∧
      Nontrivial P.baseDatum ∧ Nontrivial P.gammaModule ∧
      Nonempty P.coeffRing ∧ Nonempty P.confluenceAlgebra ∧
      Nonempty P.torsionDefect ∧ Nonempty P.resonanceDivisor ∧
      Nonempty P.pdCarrier ∧
      (∀ x, del (del x) = del x) ∧
      (∀ σ τ x, permAct (τ ∘ σ) x = permAct σ (permAct τ x)) ∧
      (∀ f g x, linAct (g ∘ f) x = linAct g (linAct f x)) := by
  refine ⟨{ support := S, confluenceMult := m, coeffExponent := ν,
            baseDatum := (S.primes → ℤ) × ℤ,
            gammaModule := (S.primes → ℤ) × ℤ,
            coeffRing := ℤ,
            confluenceAlgebra := (S.primes → ℤ) × ℤ,
            torsionDefect := (S.primes → ℤ) × ℤ,
            resonanceDivisor := (S.primes → ℤ) × ℤ,
            pdCarrier := ((S.primes → ℤ) × ℤ) × ((S.primes → ℤ) × ℤ) },
          fun _ => (0, 0),
          fun σ p => (p.1 ∘ σ, p.2),
          fun f => f,
          rfl, rfl, rfl,
          ⟨(0, 0), (0, 1), fun h => zero_ne_one (congrArg Prod.snd h)⟩,
          ⟨(0, 0), (0, 1), fun h => zero_ne_one (congrArg Prod.snd h)⟩,
          ⟨0⟩, ⟨(0, 0)⟩, ⟨(0, 0)⟩, ⟨(0, 0)⟩, ⟨((0, 0), (0, 0))⟩,
          fun x => rfl,
          fun σ τ x => by simp [Function.comp_assoc],
          fun f g x => rfl⟩

end SelmerCartanMotiveTowers
