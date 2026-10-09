# P1-3/P1-4 infeasibility record (external-verifier todo.md)

Four sub-items were assessed as **infeasible under current Mathlib**
(v4.33.1 @ 0df444a), not merely "large effort" but "no starting point".
They remain as explicitly labeled background assumptions (Strategy A).
This is the honest boundary of the project, not a deferral trick.

## M9 — successor stage functor (P1-3)

Requires: homotopy pullbacks of relative Moore objects over Moore Picard
stacks in motivic homotopy / DAG. Mathlib has no ∞-categorical homotopy
pullback, no stacks (derived or otherwise), and no motivic foundations.
Packaging functor laws is meaningless until the pullback itself is
axiomatized. → **Strategy B level rewrite; infeasible.**

## M12 — stack globalization (P1-3)

Requires: derived stacks / moduli of pseudo-perfect modules. Mathlib's
stack theory is the 1-categorical Grothendieck site version
(`CategoryTheory/Sites/Descent`); derived algebraic geometry has no
foundation. → **Infeasible.**

## M13 — marked Morita independence, Toën (P1-3)

Requires: derived Morita equivalence of dg-categories. Mathlib's Morita
theory (`RingTheory/Morita`) is the classical ring version; the gap to
Toën's derived version (dg-categories, derived functors) is a research
library, not an application. → **Infeasible.**

## M15 — gerbe provenance (P1-4)

Requires: classifying map `X_* → BŪ₃₂^cyc`, homotopy pullback producing a
μ₃₁-gerbe — genuine derived algebraic geometry (classifying stacks,
stack homotopy pullbacks). Mathlib has no foundation. → **Infeasible.**

## What was done instead (feasible scope)

| Item | Delivered |
|---|---|
| M2 (P1-3) | `SuperDGA` defined from scratch; Bianchi identity **proved**; cocycle/lifting/naturality derived. PD filtration + filler torsor marked uncovered. |
| M3 (P1-4) | Concrete Moore complex + pointed AddEquiv + q-reduction compatibility proved. |
| M10 (P1-4) | Concrete CRT product (`ZMod.chineseRemainder`), p-power reductions, Moore presentation. dg realization marked uncovered. |
| M11 (P1-3) | Target-side `ClassicalMooreCone` with proved reduction laws; source category honestly stays background. |
| M16 (P1-4) | Three concrete pointed cyclic carriers; span isomorphisms **constructed** (carrier-level only). |

## Standing position

The four infeasible items are the precise points where Strategy A meets
Mathlib's hard boundary (derived AG, motivic homotopy, derived Morita).
Advancing them requires either building large new foundations or accepting
them as permanent background assumptions. The background ledger
(`BACKGROUND_INPUTS.md`) records their assumption status explicitly.
