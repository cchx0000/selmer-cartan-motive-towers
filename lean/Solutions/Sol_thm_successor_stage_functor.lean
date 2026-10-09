namespace SelmerCartanMotiveTowers

/-- Solution for Theorem 26.7 (`thm_successor_stage_functor`), M9.

Strategy A assembly: the successor functor is the paper's construction
`S n X = mooreLift n X (nextObstruction n X)` (obstruction ledger followed by
the root-stack Moore lift, i.e. `𝔖_Mot^{(n+1)}`), and it preserves
Cartan-motivicness by the motivic-closure hypothesis on the Moore lift. -/
theorem sol_thm_successor_stage_functor
    (Stage : Nat → Type) [∀ n, Nonempty (Stage n)]
    (isCartanMotivic : ∀ n, Stage n → Prop)
    (Obstr : Type)
    (nextObstruction : ∀ n, Stage n → Obstr)
    (mooreLift : ∀ n, Stage n → Obstr → Stage (n + 1))
    (hMooreClosure : ∀ (n : Nat) (X : Stage n) (o : Obstr),
      isCartanMotivic n X → isCartanMotivic (n + 1) (mooreLift n X o))
    : ∃ S : ∀ n, Stage n → Stage (n + 1),
        ∀ (n : Nat) (X : Stage n), isCartanMotivic n X →
          isCartanMotivic (n + 1) (S n X) :=
  ⟨fun n X => mooreLift n X (nextObstruction n X),
   fun n X hX => hMooreClosure n X _ hX⟩

end SelmerCartanMotiveTowers
