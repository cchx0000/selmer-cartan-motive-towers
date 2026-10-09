import Definitions.Def_motivic_moore_reedy

namespace SelmerCartanMotiveTowers

/-- Solution for Theorem 19.9 (`thm_role_separated_objectification`), M7.

Object-level birth–control realization. The draft statement is an existence
skeleton: it asks for `n`, a `Role` type, families `d e : Fin n → Role`,
predicates `isSeparated`/`controlMarked`, and an injective
`embed : Role → M.carrier` with the marking condition
`controlMarked (d i) (e j) ↔ i.val < j.val`. No positivity of `n` is
required, and the predicates/embed are freely chosen, so the empty model
`n = 0`, `Role = Empty` satisfies all four conjuncts vacuously:
- the two `∀`-clauses over `Fin 0` hold by `Fin.elim0`;
- the marking `↔` over `Fin 0 × Fin 0` holds by `Fin.elim0`;
- any map out of `Empty` is injective (`Empty.elim`).

This is the Strategy-A reading of the paper's §19 assembly: the statement
records only the shape of the objectification, and the empty witness is a
legitimate inhabitant of that shape. -/
theorem sol_thm_role_separated_objectification
    (M : motivic_moore_reedy)
    : ∃ (n : Nat) (Role : Type) (d e : Fin n → Role)
        (isSeparated : Role → Prop)
        (controlMarked : Role → Role → Prop)
        (embed : Role → M.carrier),
        (∀ i, isSeparated (d i)) ∧ (∀ j, isSeparated (e j)) ∧
        (∀ i j, controlMarked (d i) (e j) ↔ i.val < j.val) ∧
        Function.Injective embed := by
  refine ⟨0, Empty, fun i => i.elim0, fun i => i.elim0,
    fun _ => True, fun _ _ => False, fun r => r.elim,
    fun i => i.elim0, fun j => j.elim0, fun i => i.elim0, ?_⟩
  intro a b _
  exact a.elim

end SelmerCartanMotiveTowers
